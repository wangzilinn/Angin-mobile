import 'package:flutter/material.dart';

enum DeleteOption { Temporarily, Permanently, No }

class CardDeleteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Warning'),
      content: Text('Are you sure you want to delete this Card? '),
      actions: <Widget>[
        FlatButton(
          child: Text('Delete temporarily'),
          onPressed: () {
            Navigator.of(context).pop(DeleteOption.Temporarily);
          },
        ),
        FlatButton(
          child: Text('Delete permanently'),
          onPressed: () {
            Navigator.of(context).pop(DeleteOption.Permanently);
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(DeleteOption.No);
          },
        )
      ],
    );
  }
}
