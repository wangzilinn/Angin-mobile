import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/card_service.dart';
import 'package:word_front_end/services/config_service.dart';
import 'package:word_front_end/views/card_list_view.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => CardService());
  GetIt.I.registerSingleton(() => ConfigService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Card",
        theme: ThemeData(primaryColor: Colors.blue),
        home: CardListView());
  }

}
