import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: <Widget>[
          Text(
            "选项1"
          ),
          Text(
            "选项2"
          )
        ],
      ),
    );
  }
}
