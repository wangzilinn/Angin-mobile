import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:word_front_end/models/message_model.dart';
import 'package:word_front_end/services/chat_service.dart';
import 'package:word_front_end/services/config_service.dart';

class ChatListView extends StatefulWidget {
  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  ConfigService get configService => GetIt.I<ConfigService>();

  ChatService get chatService => GetIt.I<ChatService>();

  bool isConnecting;

  String selfId;
  String peerId;

  File imageFile;
  bool isShowSticker;
  bool isLoading;
  String imageUrl;

  final focusNode = new FocusNode(); //+笔记
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onBackPress); //called when the object changes

    isLoading = false;
    isShowSticker = false;
    imageUrl = "";

    selfId = "1996";
    peerId = "1999";

    //通知服务器开始聊天服务
    initChat();
  }

  @override
  Widget build(BuildContext context) {
    print("called build");
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

  _buildListMessage() {
    print("call _buildListMessage");
    return Flexible(
      child: StreamBuilder(
        //TODO:stream:
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
    if (messageModel.userId == selfId) isRightSide = true;
    //my message
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
                        color: configService.colors[2],
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
                                  configService.colors[1]),
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

  _buildSticker() {
    return Container(
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: () => _onSendMessage('mimi1', MessageType.Sticker),
            child: new Image.asset(
              'images/mimi1.gif',
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          FlatButton(
            onPressed: () => _onSendMessage('mimi2', MessageType.Sticker),
            child: new Image.asset(
              'images/mimi2.gif',
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          FlatButton(
            onPressed: () => _onSendMessage('mimi3', MessageType.Sticker),
            child: new Image.asset(
              'images/mimi3.gif',
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  _buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          //Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: _getImage,
                color: configService.colors[0],
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: _getSticker,
              ),
            ),
            color: Colors.white,
          ),
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black54, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'type yout message..',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
//                focusNode: focusNode,
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _onSendMessage(
                    textEditingController.text, MessageType.String),
                color: configService.colors[0],
              ),
            ),
            color: Colors.white,
          )
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  _buildLoading() {
    return isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(configService.colors[1]),
              ),
            ),
          )
        : Container();
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

  void _onSendMessage(String content, MessageType messageType) {
    if (content.trim() != '') {
      textEditingController.clear();
    }
    MessageModel messageModel = MessageModel(selfId, messageType, content);
    chatService.sendMessageModel(messageModel);
  }

  void _onFocusChange() {
    //hide sticker when keybd oarappear
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
        //TODO:send message to server
        listScrollController.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    } else {
      //TODO:show nothing to send
    }
  }

  Future<File> _getImage() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery); //get image from  user's gallery
    return image;
  }

  void _getSticker() {
    //当表情出现时,关掉键盘
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future<String> _uploadFile() async {
    //TODO:upload file and return file url.
    return "";
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
}
