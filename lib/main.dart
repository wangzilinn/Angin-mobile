import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/application/card_service.dart';
import 'package:word_front_end/services/application/chat_service.dart';
import 'package:word_front_end/services/application/user_service.dart';
import 'package:word_front_end/services/platform/http_service.dart';
import 'package:word_front_end/services/platform/mqtt_serivice.dart';
import 'package:word_front_end/services/platform/storage_service.dart';
import 'package:word_front_end/views/login/login_view.dart';

void setupLocator() async {
  GetIt.I.registerLazySingleton(() => StorageService());
  GetIt.I.registerLazySingleton(() => UserService());
  GetIt.I.registerLazySingleton(() => CardService());
  GetIt.I.registerLazySingleton(() => ChatService());
  GetIt.I.registerLazySingleton(() => MqttService());
  GetIt.I.registerLazySingleton(() => HttpService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  UserService get configService => GetIt.I<UserService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Lover",
        theme: ThemeData(
          primaryColor: configService.settings["colors"][0],
          primaryColorLight: configService.settings["colors"][1],
        ),
        home: LogInView());
  }
}
