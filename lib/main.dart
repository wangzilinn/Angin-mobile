
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/card_service.dart';
import 'package:word_front_end/services/config_service.dart';
import 'package:word_front_end/services/storage_service.dart';
import 'package:word_front_end/views/navigation/navigation_view.dart';

void setupLocator() async{
  GetIt.I.registerLazySingleton(() => StorageService());
  GetIt.I.registerLazySingleton(() => ConfigService());
  GetIt.I.registerLazySingleton(() => CardService());
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
            primaryColorLight: configService.colors[1],),
        home: NavigationView());
  }

}
