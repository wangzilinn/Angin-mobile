import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/card_detail_model.dart';
import 'package:word_front_end/services/card_service.dart';

class CardEditView extends StatefulWidget {
  CardDetailModel _displayedCardModel;

  CardEditView(this._displayedCardModel);

  @override
  _CardEditViewState createState() => _CardEditViewState();
}

class _CardEditViewState extends State<CardEditView> {
  CardDetailModel get displayedCard => widget._displayedCardModel;

  CardService get cardService => GetIt.I<CardService>();

  TextEditingController _frontController = TextEditingController();
  TextEditingController _backController = TextEditingController();

  bool _ifShowSaveButton = false;

  @override
  void initState() {
    super.initState();
    _frontController.text = displayedCard.front;
    _backController.text = displayedCard.back;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height - kToolbarHeight,
          child: Column(
            children: <Widget>[
              Expanded(
//                flex: 4,
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(top: 32),
                        child: Text(
                          displayedCard.key,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    Container(
                      padding: const EdgeInsets.only(left: 32, right: 32),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: _frontController,
                        maxLines: 8,
//                        onSubmitted: (value) {print(value);},
                        onChanged: (text) {
                          print(text);
                          _ifShowSaveButton = true;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
//                flex: 4,
                child: Column(
                  children: <Widget>[
                    Container(
                        child: Text(
                      "Answer",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    Container(
                      padding: const EdgeInsets.only(left: 32, right: 32),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: _backController,
                        maxLines: 8,
                        onChanged: (text) {
                          print(text);
                          _ifShowSaveButton = true;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              _showSaveButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _showSaveButton {
    if (_ifShowSaveButton)
      return FlatButton(
        color: Theme.of(context).primaryColorLight,
        child: Text("Save Changes"),
        onPressed: _pressSaveButton,
      );
    else
      return Container();
  }

  void _pressSaveButton() {
    displayedCard.front = _frontController.text;
    displayedCard.back = _backController.text;
    cardService.updateCardDetails(displayedCard);
  }
}
