import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/chat_service.dart';
import 'package:word_front_end/services/config_service.dart';
import 'package:word_front_end/views/chat/chat_input_view.dart';

import 'chat_list_view.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ChatService get chatService => GetIt.I<ChatService>();

  ConfigService get configService => GetIt.I<ConfigService>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initChat();
  }

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
                        ChatListView(),
                        ChatInputView(),
                      ],
                    ),
                  ],
                ),
          onWillPop: _onBackPress,
        ));
  }

  Future<bool> _onBackPress() {
    print(("back"));
    return Future.value(true); //+笔记
  }

  void initChat() async {
    await chatService.connect();
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildLoading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(configService.colors[1]),
        ),
      ),
    );
  }
}
