import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/platform/storage_service.dart';

class UserService {
  static const CONFIG_FILE_NAME = "config";

  Map<String, dynamic> _data = Map();

  StorageService get storageService => GetIt.I<StorageService>();

  UserService() {
    //启动时先放入默认值, 如果本地有则覆盖
    List<Color> colors = List();
    colors
      ..add(Color.fromARGB(0xff, 139, 161, 96))
      ..add(Color.fromARGB(0xff, 211, 213, 164))
      ..add(Color.fromARGB(0xff, 135, 160, 138))
      ..add(Color.fromARGB(0xff, 93, 114, 95))
      ..add(Color.fromARGB(0xff, 56, 83, 52));

    _data["colors"] = colors;
    _data["userId"] = "wangzilin";
    _data["password"] = "19961112w";
    _data["alreadyFetchedTodayCardList"] = false;
    _data["timeStamp"] = 0;
    _data["maxReciteCardNumber"] = 10;
    _data["maxNewCardNumber"] = 10;
    _data["deadline"] = new TimeOfDay.now();
  }

  void updateSetting(String key, Object value, {bool writeToLocal = true}) {
    if (!_data.containsKey(key)) throw "传入的设置参数不存在";
    //对传入类型进行检查:
    //检查deadline:
    if (key == "deadline" && !(value is TimeOfDay)) {
      if (value is String) {
        String timeString = RegExp(r"([0-9]|0[0-9]|1[0-9]|2[0-4]):[0-5][0-9]")
            .stringMatch(value);
        List<String> hourAndMinute = timeString.split(":");
        int hour = int.parse(hourAndMinute[0]);
        int minute = int.parse(hourAndMinute[1]);
        value = new TimeOfDay(hour: hour, minute: minute);
      } else {
        throw "deadline 参数类型错误:$value.runtimeType";
      }
    }
    //检查timeStamp
    if (key == "timeStamp") {
      int currentTimeStamp = _currentTimeStamp();
      if (currentTimeStamp > _data["timeStamp"]) {
        //满足此条件则是新的一天,重新获取卡片
        _data["alreadyFetchedTodayCardList"] = false;
      }
    }
    //检查alreadyFetchedTodayCardList, 如果已经更新了, 则更新时间戳
    if (key == "alreadyFetchedTodayCardList" && value == true) {
      _data["timeStamp"] = _currentTimeStamp();
    }
    _data[key] = value;
    //将修改后的配置写入本地
    if (writeToLocal) {
      String json = jsonEncode(_data);
      storageService.writeFile(CONFIG_FILE_NAME, json);
    }
  }

  int _currentTimeStamp() {
    var dateTime = DateTime.now();
    return dateTime.year * 10000 + dateTime.month + 100 * dateTime.day;
  }

  Map get settings => _data;

  Future<void> readLocalStatusFile() async {
    final jsonString = await storageService.readFile(CONFIG_FILE_NAME);
    if (jsonString == null) {
      print("第一次运行软件, 使用默认配置, 并将默认配置写入手机");
      String json = jsonEncode(_data);
      storageService.writeFile(CONFIG_FILE_NAME, json);
    } else {
      final jsonData = json.decode(jsonString);
      for (String key in jsonData) {
        updateSetting(key, jsonData[key], writeToLocal: false);
      }
    }
  }

  void deleteLocalStatusFile() {
    storageService.deleteFile(CONFIG_FILE_NAME);
  }
}
