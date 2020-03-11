import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/application/card_service.dart';
import 'package:word_front_end/services/application/chat_service.dart';
import 'package:word_front_end/services/application/config_service.dart';
import 'package:word_front_end/services/platform/http_service.dart';
import 'package:word_front_end/services/platform/mqtt_serivice.dart';
import 'package:word_front_end/services/platform/storage_service.dart';
import 'package:word_front_end/views/navigation/navigation_view.dart';

void setupLocator() async {
  GetIt.I.registerLazySingleton(() => StorageService());
  GetIt.I.registerLazySingleton(() => ConfigService());
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
  ConfigService get configService => GetIt.I<ConfigService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Lover",
        theme: ThemeData(
          primaryColor: configService.colors[0],
          primaryColorLight: configService.colors[1],
        ),
        home: NavigationView());
  }
}
