import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/message_model.dart';
import 'package:word_front_end/services/chat_service.dart';
import 'package:word_front_end/services/config_service.dart';

import 'chat_list_view.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ChatService get chatService => GetIt.I<ChatService>();
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat list"),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        body: WillPopScope(
          child: isLoading
              ? _buildLoading()
              : Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        //TODO:List of message
                        _buildListMessage(),
                        //TODO:Sticker
                        (isShowSticker ? _buildSticker() : Container()),
                        //TODO:Input
                        _buildInput(),
                      ],
                    ),
                  ],
                ),
          onWillPop: _onBackPress,
        ));
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;

    //通知服务器开始聊天服务
    initChat();
  }

  void initChat() async {
    setState(() {
      isLoading = true;
    });
    await chatService.connect();
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> _onBackPress() {
//    if (isShowSticker) {
//      setState(() {
//        isShowSticker = false;
//      });
//    } else {
//      Navigator.pop(context); //+笔记
//    }
    print(("back"));
    return Future.value(true); //+笔记
  }
}
