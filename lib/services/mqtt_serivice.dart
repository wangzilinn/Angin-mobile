import 'package:device_info/device_info.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttService {
  MqttClient client;
  static bool hasInitialized = false;
  MqttQos globalQos;

  MqttService();

  init() async {
    if (hasInitialized) {
      print(" 已经被初始化过, 直接返回");
      return;
    }
    globalQos = MqttQos.exactlyOnce;

    client = MqttClient.withPort("47.103.194.29", "dart_test", 1883);
    client.keepAlivePeriod = 20; //20s
    client.onDisconnected = _onDisconnected; //断开连接回调
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribe;
    client.pongCallback = _pong; //ping response call back

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    final MqttConnectMessage connectMessage = MqttConnectMessage()
        .withClientIdentifier(androidInfo.id)
        .keepAliveFor(20)
        .withWillTopic("willTopic")
        .withWillMessage("willMessage")
        .withWillQos(MqttQos.exactlyOnce);

    client.connectionMessage = connectMessage;

    try {
      print("开始连接");
      await client.connect();
      hasInitialized = true;
    } on Exception catch (e) {
      print(e);
      print("出现错误, 断开连接");
      client.disconnect();
    }
  }

  void subscribe(String topic) {
    client.subscribe(topic, globalQos);
  }

  void publishString(String topic, String content) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addUTF8String(content);

    client.publishMessage(topic, globalQos, builder.payload);
  }

  get stream => client.updates;

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      print('OnDisconnected callback is solicited, this is correct');
    }
    print(client.connectionStatus.returnCode);
  }

  void _onConnected() {
    print('OnConnected client callback - Client connection was sucessful');
  }

  void _onSubscribe(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  void _pong() {
    print('Ping response client callback invoked');
  }
}
