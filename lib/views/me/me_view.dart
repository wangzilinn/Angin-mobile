import 'package:flutter/material.dart';

class MeView extends StatefulWidget {
  @override
  _MeViewState createState() => _MeViewState();
}

class _MeViewState extends State<MeView> {
  List<String> str = new List();
  int counter = 0;

  @override
  void initState() {
    super.initState();
    str
      ..add("别点了")
      ..add("说别点了呀")
      ..add("后面没啦")
      ..add("还不信")
      ..add("我爱你!!!!!")
      ..add("真没了...mua");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("me"),
      ),
      body: Center(
          child: FlatButton(
        child: Text(
          "我爱你",
          style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 40),
        ),
        onPressed: () {
          String st;
          if (counter < 5)
            st = str[0];
          else if (counter < 10)
            st = str[1];
          else if (counter < 15)
            st = str[2];
          else if (counter < 20)
            st = str[3];
          else if (counter < 35)
            st = str[4];
          else
            st = str[5];
          counter++;
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Text(st),
            duration: Duration(milliseconds: 200),
          ));
        },
      )),
    );
  }
}
