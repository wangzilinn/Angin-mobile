import 'package:flutter/material.dart';
import 'package:word_front_end/views/card_list_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "单词",
      theme: ThemeData(primaryColor: Colors.blue),
      home: CardListView()
    );
  }
}
