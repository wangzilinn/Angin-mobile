import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      title: "单词",
      home: Scaffold(
        appBar: AppBar(
          title: Text("开始背单词"),//最上面的蓝色背景上面的标题
        ),
        body: Column(
            children: [
              Expanded(//纵向延伸空间直到填满,flex是不同的权重
                flex: 1,
                child: CardFrontDetailWidget(),
              ),
              Expanded(//纵向延伸空间直到填满
                flex: 1,
                child: CardBackDetailWidget(),
              ),
              CardOptionsButtonWidget(),
            ],
        ),
      ),
    );
  }
}

class CardFrontDetailWidget extends StatefulWidget{
  @override
  _CardFrontDetailWidgetState createState() => _CardFrontDetailWidgetState();
}

class _CardFrontDetailWidgetState extends State<CardFrontDetailWidget>{
  String _innerTxt = "单词显示内容单词显示内容单词显示内容单词显示"
      "内容单词显示内容单词显示内容单词显示内容单词显示内容"
      "单词显示内容单词显示内容单词1111111111111111111显示内容";

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 32),
          child:Text(
            "卡片正面",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(32),
          child: Text(
            _innerTxt,
            softWrap: true,
          ),
        )
      ],
    );
  }
}

class CardBackDetailWidget extends StatefulWidget{
  @override
  _CardBackDeatilWidgetState createState() => _CardBackDeatilWidgetState();
}

class _CardBackDeatilWidgetState extends State<CardBackDetailWidget>{
  String _innerTxt = "单词显示内容单词显示内容单词显示内容单词显示"
      "内容单词显示内容单词显示内容单词显示内容单词显示内容"
      "单词显示内容单词显示内容单词1111111111111111111显示内容";

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Container(
//          padding: const EdgeInsets.only(top: 32),
          child:Text(
            "卡片背面",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(32),
          child: Text(
            _innerTxt,
            softWrap: true,
          ),
        )
      ],
    );
  }
}

class CardOptionsButtonWidget extends StatefulWidget{
  @override
  _CardOptionsButtonWidgetState createState() => _CardOptionsButtonWidgetState();
}

class _CardOptionsButtonWidgetState extends State<CardOptionsButtonWidget>{

  int stateCnt = 2;
  int state = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: _buildBottomButton(state),
    );
  }

  Row _buildBottomButton(int state){
    if (state == 0) {
      return Row(//不同状态的按钮
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[
          _buildOptionButton(Colors.blueAccent, Icons.chat_bubble_outline, "左边按钮填充"),
          _buildOptionButton(Colors.blueAccent, Icons.chat, "中间按钮填充"),
          _buildOptionButton(Colors.blueAccent, Icons.chat_bubble, "右边按钮填充"),
        ],
      );
    }else{
      return Row(//显示背面的按钮
        children: <Widget>[
          Expanded(//纵向延伸空间直到填满,flex是不同的权重
            flex: 1,
            child: _buildOptionButton(Colors.blueAccent, Icons.chat, "显示背面"),
          ),
        ],
      );
    }
  }

  Column _buildOptionButton(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(icon),
          color: color,
          onPressed: _pressOptionsButton,
        ),
        Container(
          margin: const EdgeInsets.only(top:8),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color
            ),
          ),
        )
      ],
    );
  }



  void _pressOptionsButton(){
    setState(() {
      if (state == 0) {
        state = 1;
      }else{
        state = 0;
      }
    });
  }
}


