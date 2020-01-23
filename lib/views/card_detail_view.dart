import 'package:flutter/material.dart';

class CardDetailView extends StatelessWidget {
  String _innerTxt = "单词显示内容";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "detail"
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              //纵向延伸空间直到填满,flex是不同的权重
              flex: 4,
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        "卡片正面",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      _innerTxt,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              //纵向延伸空间直到填满
              flex: 4,
              child: Column(
                children: <Widget>[
                  Container(
//          padding: const EdgeInsets.only(top: 32),
                    child: Text(
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
              ),
            ),
            Row(
              //不同状态的按钮
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:_buildOptionButton()
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOptionButton(){
    var buttonList = List<Widget>();
    var options = ["状态1", "状态2", "状态3", "状态3"];
    for (String item in options){
      buttonList.add(FlatButton(color: Colors.blue,child: Text(item),onPressed: _pressOptionsButton,));
    }
    return buttonList;
  }

  void _pressOptionsButton() {}
}
