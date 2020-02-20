import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:word_front_end/models/message_model.dart';
import 'package:word_front_end/services/chat_service.dart';
import 'package:word_front_end/services/config_service.dart';

class ChatInputView extends StatefulWidget {
  @override
  _ChatInputViewState createState() => _ChatInputViewState();
}

class _ChatInputViewState extends State<ChatInputView> {
  final focusNode = new FocusNode(); //+笔记
  final TextEditingController textEditingController =
  new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  ConfigService get configService => GetIt.I<ConfigService>();
  ChatService get chatService => GetIt.I<ChatService>();

  bool isShowSticker;
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _onFocusChange() {
    isShowSticker = false;
    imageUrl = "";
    //hide sticker when keybd oarappear
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
        //TODO:send message to server
//        listScrollController.animateTo(0.0,
//            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    } else {
      //TODO:show nothing to send
    }
  }
  void _getSticker() {
    //当表情出现时,关掉键盘
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }
  void _onSendMessage(String content, MessageType messageType) {
    if (content.trim() != '') {
      textEditingController.clear();
    }
    MessageModel messageModel = MessageModel(chatService.selfId, messageType, content);
    chatService.sendMessageModel(messageModel);
  }


  Future<File> _getImage() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery); //get image from  user's gallery
    return image;
  }


  Future<String> _uploadFile() async {
    //TODO:upload file and return file url.
    return "";
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
}
