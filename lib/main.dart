import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/card_service.dart';
import 'package:word_front_end/services/config_service.dart';
import 'package:word_front_end/views/bottom_navigation_view.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => CardService());
  GetIt.I.registerLazySingleton(() => ConfigService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Lover",
        theme: ThemeData(
            primaryColor: Color.fromARGB(0xff, 75, 145, 35),
            primaryColorLight: Color.fromARGB(0xff, 116, 180, 70)),
        home: BottomNavigationView());
  }
}
