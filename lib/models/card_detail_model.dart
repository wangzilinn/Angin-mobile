import 'package:flutter/material.dart';

enum CardStatus { READY, SUSPEND, DONE }

class CardDetailModel {
  String key;
  String front;
  String back;
  DateTime expirationTime;
  List<String> options;
  CardStatus status;

  CardDetailModel(
      {this.key,
      this.front,
      this.back,
      this.expirationTime,
      this.options,
      this.status});

  factory CardDetailModel.fromJson(Map<String, dynamic> item,
      {TimeOfDay deadline}) {
    //处理options:
    List<String> options = new List(); //map不能直接赋值
    for (var opt in item['options']) {
      options.add(opt);
    }

    //处理卡片状态:
    DateTime expirationTime = DateTime.parse(item['expireDate']);
    CardStatus cardStatus;
    //获得当前卡片的状态:

    if (deadline != null) {
      var now = DateTime.now();
      var deadlineDateTime = DateTime(
          now.year, now.month, now.day, deadline.hour, deadline.minute);
      if (expirationTime.isBefore(DateTime.now()))
        cardStatus = CardStatus.READY;
      else if (expirationTime.isBefore(deadlineDateTime))
        cardStatus = CardStatus.SUSPEND;
      else
        cardStatus = CardStatus.DONE;
    } else {
      //如果没传入当日死线,说明是首次获得卡片信息,则肯定是要背的
      cardStatus = CardStatus.READY;
    }

    return CardDetailModel(
        key: item['key'],
        front: item['front'],
        back: item['back'],
        expirationTime: expirationTime,
        options: options,
        status: cardStatus);
  }

  Map<String, dynamic> get toJson =>{
    "key":key,
    "front":front,
    "back":back,
    //这里上传到服务器只用写这么多
  };
}
