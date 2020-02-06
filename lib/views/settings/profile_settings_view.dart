import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/config_service.dart';

class ProfileSettingsView extends StatefulWidget {
  @override
  _ProfileSettingsViewState createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  ConfigService get configService => GetIt.I<ConfigService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Builder(builder: (context) {
        return ListView(
          children: <Widget>[
            Divider(
              thickness: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
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
            ),
            Divider(
              thickness: 10,
            ),
          ],
        );
      }),
    );
  }
}
