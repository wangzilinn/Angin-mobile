import 'package:mqtt_client/mqtt_client.dart';

class ChatService {
  MqttClient client;

  bool isConnected = false;

  ChatService() {
    client = MqttClient.withPort("47.103.194.29", "dart_test", 1883);
  }

  connect() async {
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

    print("client connecting...");
    client.connectionMessage = connectMessage;

    try {
      await client.connect();
    } on Exception catch (e) {
      print(e);
      client.disconnect();
    }

    const String subTopic = 'chat';
    client.subscribe(subTopic, MqttQos.exactlyOnce);
  }

  void sendMessage(String message) {
    const String pubTopic = 'chat';
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
  }

  Stream<String> getTheLatestMessage() {
    return client.updates.map((List<MqttReceivedMessage<MqttMessage>> data) {
      final MqttPublishMessage mqttPublishMessage = data[0].payload;
      final String pt = MqttPublishPayload.bytesToStringAsString(
          mqttPublishMessage.payload.message);
      return pt;
    });
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      print('OnDisconnected callback is solicited, this is correct');
    }
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
