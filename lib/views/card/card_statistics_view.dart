import 'package:flutter/material.dart';

class CardStatisticsView extends StatefulWidget {
  @override
  _CardStatisticsViewState createState() => _CardStatisticsViewState();
}

class _CardStatisticsViewState extends State<CardStatisticsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Card statistics"),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Text("这页放背单词的统计数据"),
    );
  }
}
