import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardPaletteView extends StatefulWidget {
  @override
  _CardPaletteViewState createState() => _CardPaletteViewState();
}

class _CardPaletteViewState extends State<CardPaletteView> {
  @override
  Widget build(BuildContext context) {
    var images = List<String>();
    images..add("11")..add("22")..add("value")..add("value3");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text("Card Palette"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return new Image.network(
                  "http://via.placeholder.com/288x188",
                  fit: BoxFit.fill,
                );
              },
              itemCount: 10,
              itemWidth: 300.0,
              layout: SwiperLayout.STACK,
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
                width: double.infinity,
                child: Container(
                    color: Colors.red,
                    child: Text(
                      "tet",
                      style: TextStyle(color: Colors.red),
                    ))),
          )
        ],
      ),
    );
  }
}
