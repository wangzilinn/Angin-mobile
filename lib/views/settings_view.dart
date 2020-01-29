import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/config_service.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  ConfigService get configService => GetIt.I<ConfigService>();

  TextEditingController _maxReciteCardNumberController =
      TextEditingController();
  TextEditingController _maxNewCardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _maxNewCardNumberController.text =
        configService.settings.maxReciteCardNumber.toString();
    _maxReciteCardNumberController.text =
        configService.settings.maxNewCardNumber.toString();
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
            Text("以下两个设置第二天才生效", style: TextStyle(
              fontSize: 15,
            ),),
            TextField(
              decoration: InputDecoration(
                labelText: "每日最大复习单词数量",
              ),
              keyboardType: TextInputType.number,
              controller: _maxReciteCardNumberController,
              onChanged: (data){
                _updateMaxReciteCardNumber(int.parse(data));
              }
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "每日最大新单词数量",
              ),
              keyboardType: TextInputType.number,
              controller: _maxNewCardNumberController,
              onChanged: (data){
                _updateMaxNewCardNumber(int.parse(data));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateMaxReciteCardNumber(int newValue) {
    configService.updateSettings(maxReciteCardNumber: newValue);
  }

  void _updateMaxNewCardNumber(int newValue){
    configService.updateSettings(maxNewCardNumber: newValue);
  }

}
