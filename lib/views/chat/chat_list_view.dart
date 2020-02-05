import 'package:flutter/material.dart';

class ChatListView extends StatefulWidget {
  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
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
      body: Text("这页放聊天功能"),
    );
  }
}
