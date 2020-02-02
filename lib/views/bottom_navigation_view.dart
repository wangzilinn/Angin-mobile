import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:word_front_end/views/card/card_list_view.dart';
import 'package:word_front_end/views/card/card_statistics_view.dart';
import 'package:word_front_end/views/chat/chat_list_view.dart';
import 'package:word_front_end/views/me/me_view.dart';

class BottomNavigationView extends StatefulWidget {
  @override
  _BottomNavigationViewState createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  int _currentIndex = 0;
  List<Widget> views = List<Widget>();

  @override
  void initState() {
    super.initState();
    views
      ..add(CardListView())
      ..add(CardStatisticsView())
      ..add(ChatListView())
      ..add(MeView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.list, size: 30),
          Icon(Icons.apps, size: 30),
          Icon(Icons.group, size: 30),
          Icon(Icons.person, size: 30),
        ],
        color:Theme.of(context).primaryColor,
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
