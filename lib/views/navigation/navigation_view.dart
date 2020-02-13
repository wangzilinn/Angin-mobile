import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:word_front_end/views/card/card_list_view.dart';
import 'package:word_front_end/views/card/card_palette_view.dart';
import 'package:word_front_end/views/card/card_settings_view.dart';
import 'package:word_front_end/views/card/card_statistics_view.dart';
import 'package:word_front_end/views/chat/chat_list_view.dart';
import 'package:word_front_end/views/settings/settings_view.dart';

class NavigationView extends StatefulWidget {
  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int _currentIndex = 0;
  List<Widget> views = List<Widget>();

  @override
  void initState() {
    super.initState();
    views
      ..add(CardPaletteView())
      ..add(CardListView())
      ..add(CardStatisticsView())
      ..add(ChatListView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SettingsView()));
              },
            )
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: views,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.palette, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.show_chart, size: 30),
          Icon(Icons.group, size: 30),
        ],
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
