import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/application/chat_service.dart';
import 'package:word_front_end/services/application/user_service.dart';
import 'package:word_front_end/views/chat/chat_input_view.dart';

import 'messages_list_view.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ChatService get chatService => GetIt.I<ChatService>();

  UserService get configService => GetIt.I<UserService>();

  bool _isLoading;

  @override
  void initState() async {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    await chatService.refreshChat();
    setState(() {
      _isLoading = false;
    });
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
          child: _isLoading
              ? _buildLoading()
              : Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        MessagesListView(),
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


  Widget _buildLoading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              configService.settings["colors"][1]),
        ),
      ),
    );
  }
}
