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
      ),
    );
  }
}
