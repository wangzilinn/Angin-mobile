import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/message_model.dart';
import 'package:word_front_end/services/application/chat_service.dart';
import 'package:word_front_end/services/application/user_service.dart';

class MessagesListView extends StatelessWidget {
  UserService get configService => GetIt.I<UserService>();

  ChatService get chatService => GetIt.I<ChatService>();

  File imageFile;
  bool isShowSticker;
  String imageUrl;

  final ScrollController listScrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    print("call chat list view build()");
    return _buildListMessage();
  }

  _buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        initialData: chatService.messageList,
        stream: chatService.getTheLatestMessageList(),
        builder: (context, snap) {
          if (snap.hasData) {
            print("data length: ${snap.data.length}");
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  _buildItem(index, snap.data[index]),
              itemCount: snap.data.length,
              controller: listScrollController,
              reverse: true,
            );
          }
          return Container();
        },
      ),
    );
  }

  _buildItem(int index, MessageModel messageModel) {
    bool isRightSide = false;
    if (messageModel.userId == chatService.selfId) isRightSide = true;
    return Container(
      child: Row(
        mainAxisAlignment:
            isRightSide ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Builder(
            builder: (_) {
              switch (messageModel.type) {
                case MessageType.String:
                  return Container(
                    child: Text(
                      messageModel.content,
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: configService.settings["colors"][2],
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: isRightSide
                        ? EdgeInsets.only(bottom: 10.0, right: 10.0)
                        : EdgeInsets.only(bottom: 10.0, left: 10.0),
                  );
                case MessageType.Image:
                  return Container(
                    child: FlatButton(
                      child: Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  configService.settings["colors"][1]),
                            ),
                            width: 200.0,
                            height: 200.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Container(
                                width: 200.0,
                                height: 200.0,
                                child: Text("load failed")),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge, //+笔记
                          ),
                          imageUrl: messageModel.content,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      onPressed: () {},
                    ),
                    margin: isRightSide
                        ? EdgeInsets.only(bottom: 10.0, right: 10.0)
                        : EdgeInsets.only(bottom: 10.0, left: 10.0),
                  );
                case MessageType.Sticker:
                  return Container(
                    child: Image.asset('images/${messageModel.content}.gif}',
                        width: 100.0, height: 100.0, fit: BoxFit.cover),
                    margin: isRightSide
                        ? EdgeInsets.only(bottom: 10.0, right: 10.0)
                        : EdgeInsets.only(bottom: 10.0, left: 10.0),
                  );
                default:
                  return Container();
              }
            },
          )
        ],
      ),
    );
  }
}
