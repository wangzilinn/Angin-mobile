import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/displayed_card_model.dart';
import 'package:word_front_end/services/card_service.dart';

class CardDetailView extends StatefulWidget {
  DisplayedCardModel _displayedCardModel;

  CardDetailView(this._displayedCardModel);

  @override
  _CardDetailViewState createState() => _CardDetailViewState();
}

class _CardDetailViewState extends State<CardDetailView> {
  DisplayedCardModel get displayedCard => widget._displayedCardModel;

  set displayedCard(DisplayedCardModel displayedCardModel) =>
      widget._displayedCardModel = displayedCardModel;

  CardService get cardService => GetIt.I<CardService>();

  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("detail"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              //纵向延伸空间直到填满,flex是不同的权重
              flex: 4,
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        displayedCard.key,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      displayedCard.front,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              //纵向延伸空间直到填满
              flex: 4,
              child: Column(
                children: <Widget>[
                  Container(
//          padding: const EdgeInsets.only(top: 32),
                    child: Text(
                      "答案",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      _showAnswer ? displayedCard.back : "",
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),
            _showAnswer ? _buildOptionButton() : _buildShowAnswerButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton() {
    var buttonList = List<Widget>();
    var options = displayedCard.options;
    for (String item in options) {
      buttonList.add(FlatButton(
        color: Colors.blue,
        child: Text(item),
        onPressed: () => _pressOptionsButton(item),
      ));
    }
    return Row(
        //不同状态的按钮
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttonList);
  }

  Widget _buildShowAnswerButton() {
    return FlatButton(
      color: Colors.blue,
      child: Text("查看答案"),
      onPressed: _pressShowAnswerButton,
    );
  }

  void _pressOptionsButton(String option) {
    cardService.updateCardStatus(displayedCard.key, option);
    displayedCard = cardService.next();
    setState(() {
      _showAnswer = false;
    });
  }

  void _pressShowAnswerButton() {
    setState(() {
      _showAnswer = true;
    });
  }
}
