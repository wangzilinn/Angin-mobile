import 'package:flutter/material.dart';
import 'package:word_front_end/services/card_service.dart';
import 'package:word_front_end/views/card_detail_view.dart';
import 'package:word_front_end/views/settings_view.dart';

class CardListView extends StatefulWidget {
  @override
  _CardListViewState createState() => _CardListViewState();
}

class _CardListViewState extends State<CardListView> {
//  CardService get service => GetIt.I<CardService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("today cards"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SettingsView()));
            },
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (_, index) {
            return ListTile(
              title: Text("title",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              subtitle: Text("sub title"),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => CardDetailView()));
              },
            );
          },
          separatorBuilder: (_, __) {
            return Divider(
              height: 1,
              color: Colors.green,
            );
          },
          itemCount: 10),
    );
  }
}
