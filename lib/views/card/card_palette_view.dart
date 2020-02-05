import 'package:flutter/material.dart';

class CardPaletteView extends StatefulWidget {
  @override
  _CardPaletteViewState createState() => _CardPaletteViewState();
}

class _CardPaletteViewState extends State<CardPaletteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Card Palette"
        ),
      ),
    );
  }
}
