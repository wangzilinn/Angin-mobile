import 'package:flutter/material.dart';

class ChatListView extends StatefulWidget {
  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  bool isShowSticker;
  var focusNode = FocusNode();//+笔记
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
        body: WillPopScope(//返回时关掉键盘
          child: Stack(
            children: <Widget>[
              //TODO:List of message
              buildListMessage(),
              //TODO:Sticker
              (isShowSticker ? buildStciker():Container()),
              //TODO:Loading
              buildInput(),
            ],
          ),
          onWillPop: onBackPress,
        ));
  }

  buildListMessage() {}

  buildStciker() {}

  buildInput() {}

  Future<bool> onBackPress() {
    if( isShowSticker) {
    setState(() {
      isShowSticker = false;
    });
    }else{
      Navigator.pop(context);//+笔记
    }
    return Future.value(false);//+笔记
  }

  void getSticker(){
    //当表情出现时,关掉键盘

  }
}
