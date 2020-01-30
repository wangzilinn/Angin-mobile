import 'package:flutter/material.dart';

class LocalStatusModel{
  bool alreadyFetchedTodayCardList;

  int maxReciteCardNumber;
  int maxNewCardNumber;
  TimeOfDay deadline;

  LocalStatusModel({this.maxReciteCardNumber, this.maxNewCardNumber, this.deadline, this.alreadyFetchedTodayCardList});
}