import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:word_front_end/models/message_model.dart';

class ChatService {
  MqttClient client;

  List<MessageModel> messageList;

  bool hasInitialized = false;

  static bool save = true;

  ChatService() {
    client = MqttClient.withPort("47.103.194.29", "dart_test", 1883);
  }

  connect() async {

    //MQTT
    client.keepAlivePeriod = 20; //20s
    client.onDisconnected = _onDisconnected; //断开连接回调
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribe;
    client.pongCallback = _pong; //ping response call back

    final MqttConnectMessage connectMessage = MqttConnectMessage()
        .withClientIdentifier("phone1")
        .keepAliveFor(20)
        .withWillTopic("willTopic")
        .withWillMessage("willMessage")
        .withWillQos(MqttQos.exactlyOnce);

    client.connectionMessage = connectMessage;

    if (!hasInitialized){
      try {
        //TODO:读取本地消息历史
        //TODO:读取错过的消息
        messageList = new List();
        //连接并订阅主题
        print("client connecting...");
        await client.connect();
        const String subTopic = 'chat';
        client.subscribe(subTopic, MqttQos.exactlyOnce);
        hasInitialized = true;

      } on Exception catch (e) {
        print(e);
        print("出现错误, 断开连接");
        client.disconnect();
      }
    }
  }

//  get messageList => _messageList.reversed;//这样最后发出的消息才在最下面

  void sendMessageModel(MessageModel messageModel){
    String json = jsonEncode(messageModel);
    _sendString(json);
  }

  void _sendString(String string) {
    const String pubTopic = 'chat';
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addUTF8String(string);

    client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
  }



  Stream<List<MessageModel>> getTheLatestMessageList() {
    return client.updates.map((List<MqttReceivedMessage<MqttMessage>> data) {
      String re = "";
      for(var item in data){
        final MqttPublishMessage mqttPublishMessage = item.payload;
        String pt = Utf8Decoder().convert(mqttPublishMessage.payload.message);
        re += pt;
      }
      print("map1: " + re);
//      if(save == true){
        messageList.insert(0, MessageModel.fromJson(jsonDecode(re)));
//        save = false;
        return messageList;
//      }
//      save = true;
//      return messageList;
    }).asBroadcastStream();
  }


  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      print('OnDisconnected callback is solicited, this is correct');
    }
    print(client.connectionStatus.returnCode);
  }

  void _onConnected() {
    print(
        'OnConnected client callback - Client connection was sucessful');
  }

  void _onSubscribe(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  void _pong() {
    print('Ping response client callback invoked');
  }
}
