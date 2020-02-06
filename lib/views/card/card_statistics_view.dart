import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

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
      body: Container(
        color: Colors.red,
        child: Echarts(
          option: '''
    {
      xAxis: {
        type: 'category',
        data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
      },
      yAxis: {
        type: 'value'
      },
      series: [{
        data: [820, 932, 901, 934, 1290, 1330, 1320],
        type: 'line'
      }]
    }
  ''',
        ),
        width: 300,
        height: 250,
      ),
    );
  }
}
