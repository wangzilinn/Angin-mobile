import 'package:flutter/material.dart';
import 'package:word_front_end/views/card/card_settings_view.dart';
import 'package:word_front_end/views/settings/profile_settings_view.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          Divider(
            thickness: 10,
          ),
          ListTile(
            title: Text("Profile"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProfileSettingsView()));
            },
          ),
          Divider(
            thickness: 10,
          ),
          ListTile(
            title: Text("Card"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CardSettingsView()));
            },
          ),
          ListTile(
            title: Text("Chat"),
          ),
        ],
      ),
    );
  }
}
