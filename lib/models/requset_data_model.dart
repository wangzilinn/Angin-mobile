import 'dart:convert';

import 'package:flutter/cupertino.dart';

class RequestDataModel {
  String userId;
  String password;
  String channelName;

  RequestDataModel(
      {@required this.userId, @required this.password, this.channelName});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> mainData = {'userId': userId, 'password': password};

    Map additionalData = Map<String, dynamic>();
    additionalData.addAll(mainData);
    if (channelName != null) additionalData["channelName"] = channelName;
    return additionalData;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
