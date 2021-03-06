import 'dart:async';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:word_front_end/models/data_request_model.dart';
import 'package:word_front_end/models/data_response_model.dart';
import 'package:word_front_end/models/message_model.dart';
import 'package:word_front_end/services/application/user_service.dart';
import 'package:word_front_end/services/platform/http_service.dart';
import 'package:word_front_end/services/platform/mqtt_serivice.dart';

class ChatService {
  MqttService get mqttService => GetIt.I<MqttService>();

  UserService get userService => GetIt.I<UserService>();

  HttpService get httpService => GetIt.I<HttpService>();

  List<MessageModel> messageList;
  List<String> channelList;

  String selfId;
  String password;
  String peerId = "huangyiqin";

  static bool save = true;

  final messageStream = StreamController<List<MessageModel>>();

  ChatService() {
    messageList = List();
    channelList = List();
    selfId = userService.settings["userId"];
    password = userService.settings["password"];
  }

  Future<DataResponseModel<List<MessageModel>>> _getHistoryMessage() {
    String api = "/chat/getHistory";
    return httpService.get(api).then((data) {
      if (data.statusCode == 200) {
        var utf8decoder = new Utf8Decoder();
        final jsonData = jsonDecode(utf8decoder.convert(data.bodyBytes));
        final messages = <MessageModel>[];
        for (var item in jsonData) {
          MessageModel messageModel = MessageModel.fromJson(item);
          messages.insert(0, messageModel); //越晚的消息越在数组的上面
        }
        return DataResponseModel<List<MessageModel>>(data: messages);
      }
      return DataResponseModel<List<MessageModel>>(
          error: true, errorMessage: "Load message history failed");
    });
  }

  refreshChannelList() async {
    var userChannel = await _fetchUserChannel();
    if (!userChannel.error) {
      channelList = userChannel.data;
    } else {
      print("获得channel失败");
    }
  }

  refreshChat() async {
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

  Future<DataResponseModel<List<String>>> _fetchUserChannel() {
    String api = "/chat/userChannelList";
    DataRequestModel requestDataModel = DataRequestModel(selfId, password);
    return httpService
        .post(api, body: requestDataModel.toString())
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(Utf8Decoder().convert(data.bodyBytes));

        return DataResponseModel<List<String>>(
            data: List<String>.from(jsonData));
      }
      return DataResponseModel<List<String>>(
          error: true, errorMessage: "Load user channel failed");
    });
  }
}
