import 'dart:convert';

import 'package:flutter/cupertino.dart';

class RequestDataModel {
  String userId;
  String password;
  Map<String, dynamic> additionalData;

  RequestDataModel(
      {@required this.userId, @required this.password, this.additionalData});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {'userId': userId, 'password': password};
    if (additionalData != null) {
      data.addAll(additionalData);
    }
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
