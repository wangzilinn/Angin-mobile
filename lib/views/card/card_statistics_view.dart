import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class CardStatisticsView extends StatefulWidget {
  @override
  _CardStatisticsViewState createState() => _CardStatisticsViewState();
}

class _CardStatisticsViewState extends State<CardStatisticsView> {
  @override
  Widget build(BuildContext context) {
    var data = [
      new ClicksPerYear('2016', 12, Colors.red),
      new ClicksPerYear('2017', 42, Colors.yellow),
      new ClicksPerYear('2018', 30, Colors.green),
    ];

    var series = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        data: data,
      ),
    ];

    var series2 = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (ClicksPerYear clickData, _) => int.parse(clickData.year),
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        data: data,
      ),
    ];

    var chart1 = new charts.BarChart(
      series,
      animate: true,
    );
    var chart2 = new charts.LineChart(
      series2,
      animate: true,
      domainAxis: charts.NumericAxisSpec( // 主轴的配置
//        tickFormatterSpec: DomainFormatterSpec(widget.dateRange), // tick 值的格式化，这里把 num 转换成 String
        renderSpec: charts.SmallTickRendererSpec( // 主轴绘制的配置
          tickLengthPx: 0, // 刻度标识突出的长度
          labelOffsetFromAxisPx: 12, // 刻度文字距离轴线的位移
//          labelStyle: charts.TextStyleSpec( // 刻度文字的样式
//            color: ChartUtil.getChartColor(HColors.lightGrey),
//            fontSize: HFontSizes.smaller.toInt(),
//          ),
//          axisLineStyle: charts.LineStyleSpec( // 轴线的样式
//            color: ChartUtil.getChartColor(ChartUtil.lightBlue),
//          ),
        ),
        tickProviderSpec: charts.BasicNumericTickProviderSpec( // 轴线刻度配置
          zeroBound:false,
          dataIsInWholeNumbers: false,
          desiredTickCount: 3, // 期望显示几个刻度
        ),
      ),
    );
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
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: chart1),
          Expanded(
            flex: 5,
            child: chart2,
          )
        ],
      ),
    );
  }
}
