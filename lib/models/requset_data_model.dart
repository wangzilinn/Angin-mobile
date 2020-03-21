import 'dart:convert';

import 'package:flutter/cupertino.dart';

class RequestDataModel {
  String userId;
  String password;
  String channelName;

  RequestDataModel(
      {@required this.userId, @required this.password, this.channelName});

  Map<String, dynamic> toJson() {
    Map mainData = {'userId': userId, 'password': password};

    Map additionalData = Map();
    additionalData.addEntries(mainData.entries);
    if (channelName != null) additionalData["channelName"] = channelName;
    return additionalData;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
