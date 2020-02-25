import 'dart:async';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:word_front_end/models/data_response_model.dart';
import 'package:word_front_end/models/message_model.dart';
import 'package:word_front_end/services/mqtt_serivice.dart';

class ChatService {
  MqttService get mqttService => GetIt.I<MqttService>();

  List<MessageModel> messageList;

  String selfId = "1996";
  String peerId = "1999";

  static bool save = true;

  final messageStream = StreamController<List<MessageModel>>();

  ChatService() {
    messageList = List();
  }

  Future<DataResponseModel<List<MessageModel>>> _getHistoryMessage() {
    const API = "http://47.103.194.29:8080/";
    const header = {'Content-Type': "application/json"};
    String url = API + "getHistory";
    return http.get(url, headers: header).then((data) {
      if (data.statusCode == 200) {
        var utf8decoder = new Utf8Decoder();
        final jsonData = jsonDecode(utf8decoder.convert(data.bodyBytes));
        final messages = <MessageModel>[];
        for (var item in jsonData) {
          MessageModel messageModel = MessageModel.fromJson(item);
          messages.add(messageModel);
        }
        return DataResponseModel<List<MessageModel>>(data: messages);
      }
      return DataResponseModel<List<MessageModel>>(
          error: true, errorMessage: "Load message history failed");
    });
  }

  init() async {
    try {
      //读取历史的消息
      await _getHistoryMessage().then((response) {
        if (!response.error) {
          messageList.addAll(response.data);
        } else {
          return;
        }
      });
      //连接MQTT服务
      print("client connecting...");
      await mqttService.init();
      mqttService.subscribe("chat");
    } on Exception catch (e) {
      print(e);
      print("初始化聊天服务错误");
    }

    //使用自己创建的流来向chatView发送数据, 而不是使用mqtt包自带的流, 这就解决了重复注册的问题, 而且易于拓展
    mqttService.stream.map((List<MqttReceivedMessage<MqttMessage>> data) {
      String re = "";
      for (var item in data) {
        final MqttPublishMessage mqttPublishMessage = item.payload;
        String pt = Utf8Decoder().convert(mqttPublishMessage.payload.message);
        re += pt;
      }
      return MessageModel.fromJson(jsonDecode(re));
    }).listen((onData) {
      messageList.insert(0, onData);
      messageStream.sink.add(messageList);
    });
  }

  void sendMessageModel(MessageModel messageModel) {
    String json = jsonEncode(messageModel);
    mqttService.publishString("chat", json);
  }

  Stream<List<MessageModel>> getTheLatestMessageList() {
    print("registe fun: getTheLatestMessageList");
    return messageStream.stream;
  }
}
