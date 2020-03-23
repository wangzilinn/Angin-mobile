import 'dart:convert';

class DataRequestModel {
  String userId;
  String password;
  Map<String, dynamic> additionalData;

  DataRequestModel(this.userId, this.password, {this.additionalData});

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
