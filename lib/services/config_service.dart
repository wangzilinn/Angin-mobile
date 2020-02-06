import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/local_status_model.dart';
import 'package:word_front_end/services/storage_service.dart';

class ConfigService {
  static const CONFIG_FILE_NAME = "config";

  //储存所有本地配置
  LocalStatusModel _localStatusModel;

  StorageService get storageService => GetIt.I<StorageService>();

  List<Color> colors = List();

  ConfigService() {
    colors
      ..add(Color.fromARGB(0xff, 139, 161, 96))
      ..add(Color.fromARGB(0xff, 211, 213, 164))
      ..add(Color.fromARGB(0xff, 135, 160, 138))
      ..add(Color.fromARGB(0xff, 93, 114, 95))
      ..add(Color.fromARGB(0xff, 56, 83, 52));
  }

  void updateSettings(
      {int maxReciteCardNumber,
      int maxNewCardNumber,
      bool alreadyFetchedTodayCardList,
      TimeOfDay deadline}) {
    if (maxReciteCardNumber != null) {
      _localStatusModel.maxNewCardNumber = maxReciteCardNumber;
    }
    if (maxNewCardNumber != null) {
      _localStatusModel.maxNewCardNumber = maxNewCardNumber;
    }
    if (alreadyFetchedTodayCardList != null) {
      _localStatusModel.alreadyFetchedTodayCardList =
          alreadyFetchedTodayCardList;
    }
    if (deadline != null) {
      _localStatusModel.deadline = deadline;
    }
    _saveLocalStatus();
  }

  LocalStatusModel get settings => _localStatusModel;

  void _saveLocalStatus() {
    String json = jsonEncode(_localStatusModel);
    print("save config:" + json);
    storageService.writeFile(CONFIG_FILE_NAME, json);
  }

  Future<void> readLocalStatusFile() async {
    final jsonString = await storageService.readFile(CONFIG_FILE_NAME);
    if (jsonString == null) {
      print("第一次运行软件, 导入默认配置");
      _localStatusModel = LocalStatusModel(
          maxReciteCardNumber: 4,
          maxNewCardNumber: 1,
          deadline: TimeOfDay(hour: 23, minute: 50),
          alreadyFetchedTodayCardList: false);
      _saveLocalStatus();
    } else {
      final jsonData = json.decode(jsonString);
      _localStatusModel = LocalStatusModel.fromJson(jsonData);
    }
  }

  void deleteLocalStatusFile() {
    storageService.deleteFile(CONFIG_FILE_NAME);
  }
}
