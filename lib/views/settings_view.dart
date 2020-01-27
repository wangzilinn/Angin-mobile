import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  TextEditingController _maxReciteCardNumberController = TextEditingController(text: "4");
  TextEditingController _maxNewCardNumberController = TextEditingController(text: "2");

  bool _settingChanged = false;

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "每日最大复习单词数量",
              ),
              keyboardType: TextInputType.number,
              controller: _maxReciteCardNumberController,
              onChanged: (value){
                _settingChanged = true;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "每日最大新单词数量",
              ),
              keyboardType: TextInputType.number,
              controller: _maxNewCardNumberController,
            ),
          ],
        ),
      ),
    );
  }
}
