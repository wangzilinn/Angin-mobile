import 'package:flutter/material.dart';

class LocalStatusModel {
  bool alreadyFetchedTodayCardList;
  int timeStamp;

  int maxReciteCardNumber;
  int maxNewCardNumber;
  TimeOfDay _deadline;

  LocalStatusModel(
      {this.maxReciteCardNumber,
      this.maxNewCardNumber,
      deadline,
      this.alreadyFetchedTodayCardList}) {
    _deadline = deadline;
    timeStamp = _currentTimeStamp();
  }

  LocalStatusModel.fromJson(Map<String, dynamic> json) {
    alreadyFetchedTodayCardList = json["alreadyFetchedTodayCardList"];
    maxReciteCardNumber = json["maxReciteCardNumber"];
    maxNewCardNumber = json["maxNewCardNumber"];
    deadline = json["deadline"];
    timeStamp = json["timeStamp"];

    int currentTimeStamp = _currentTimeStamp();
    if (currentTimeStamp > timeStamp){
      //满足此条件则是新的一天,重新获取卡片
      alreadyFetchedTodayCardList = false;
    }

  }

  Map<String, dynamic> toJson() => {
        "alreadyFetchedTodayCardList": alreadyFetchedTodayCardList,
        "maxReciteCardNumber": maxReciteCardNumber,
        "maxNewCardNumber": maxNewCardNumber,
        "deadline": deadline.toString(),
        "timeStamp" :timeStamp,
      };

  //TimeOfDay类的初始化操作:
  TimeOfDay get deadline => _deadline;

  set deadline(dynamic deadline) {
    if (deadline is TimeOfDay) {
      _deadline = deadline;
    } else if (deadline is String) {
      String timeString = RegExp(r"([0-9]|0[0-9]|1[0-9]|2[0-4]):[0-5][0-9]")
          .stringMatch(deadline);
      List<String> hourAndMinute = timeString.split(":");
      int hour = int.parse(hourAndMinute[0]);
      int minute = int.parse(hourAndMinute[1]);

      _deadline = new TimeOfDay(hour: hour, minute: minute);
    }
  }

  int  _currentTimeStamp() {
    var dateTime = DateTime.now();
    return dateTime.year * 10000 + dateTime.month + 100 * dateTime.day;
  }
}
