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
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "卡片设置:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                  decoration: InputDecoration(
                    labelText: "每日最大复习单词数量",
                  ),
                  keyboardType: TextInputType.number,
                  controller: _maxReciteCardNumberController,
                  onChanged: (data) {
                    _updateMaxReciteCardNumber(int.parse(data));
                  }),
              TextField(
                decoration: InputDecoration(
                  labelText: "每日最大新单词数量",
                ),
                keyboardType: TextInputType.number,
                controller: _maxNewCardNumberController,
                onChanged: (data) {
                  _updateMaxNewCardNumber(int.parse(data));
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Text("设置当日截至时间")),
                  FlatButton(
                    child: Text(
                      "选择时间",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColorLight,
                    onPressed: () => _showDeadlineTimePicker(),
                  ),
                ],
              ),
              Divider(
                  thickness: 2,
                  height: 40,
                  color: Theme.of(context).primaryColorLight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("删除本地配置数据:"),
                  FlatButton(
                    child: Text(
                      "删除",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColorLight,
                    onPressed: () {
                      configService.deleteLocalStatusFile();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text("已删除本地配置数据"),
                        duration: Duration(milliseconds: 200),
                      ));
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("从服务器重新获取单词今日单词列表"),
                  FlatButton(
                    child: Text(
                      "重新获取",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColorLight,
                    onPressed: () {
                      configService.settings.alreadyFetchedTodayCardList =
                          false;
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text("已更新配置"),
                        duration: Duration(milliseconds: 200),
                      ));
                    },
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  void _updateMaxReciteCardNumber(int newValue) {
    configService.updateSettings(maxReciteCardNumber: newValue);
  }

  void _updateMaxNewCardNumber(int newValue) {
    configService.updateSettings(maxNewCardNumber: newValue);
  }

  void _showDeadlineTimePicker() async {
    var deadline =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    configService.updateSettings(deadline: deadline);
  }
}
