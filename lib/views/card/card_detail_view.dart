import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/card_detail_model.dart';
import 'package:word_front_end/services/card_service.dart';

class CardDetailView extends StatefulWidget {
  CardDetailModel _displayedCardModel;

  CardDetailView(this._displayedCardModel);

  @override
  _CardDetailViewState createState() => _CardDetailViewState();
}

class _CardDetailViewState extends State<CardDetailView> {
  CardDetailModel get displayedCard => widget._displayedCardModel;

  set displayedCard(CardDetailModel displayedCardModel) =>
      widget._displayedCardModel = displayedCardModel;

  CardService get cardService => GetIt.I<CardService>();

  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Column(
        children: [
          Expanded(
            //纵向延伸空间直到填满,flex是不同的权重
            flex: 7,
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(top: 32),
                    child: Text(
                      displayedCard.key,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
            flex: 7,
            child: Column(
              children: <Widget>[
                _showAnswer?
                Container(
                  child: Text(
                    "答案",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ):Container(),
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
          _showAnswer ? _buildOptionButton() : _buildShowAnswerButton()
        ],
      ),
    );
  }

  Widget _buildOptionButton() {
    var options = displayedCard.options;
    var bottomNavigationBarItemList = List<BottomNavigationBarItem>();
    for (String item in options) {
      var bottomNavigationBarItem = BottomNavigationBarItem(
          icon: Icon(Icons.details),
          title: Text(
            item,
            softWrap: true,
            maxLines: 2,
            style: TextStyle(fontSize: 15, color: Colors.black),
          ));
      bottomNavigationBarItemList.add(bottomNavigationBarItem);
    }
    return Expanded(
      flex: 2,
      child: SizedBox(
        width: double.infinity,
        child: BottomNavigationBar(
          currentIndex: 1,
          type: BottomNavigationBarType.fixed,
          items: bottomNavigationBarItemList,
          onTap: (int index) => _pressOptionsButton(options[index]),
        ),
      ),
    );
  }

  Widget _buildShowAnswerButton() {
    return Expanded(
      flex: 1,
      child: SizedBox(
          width: double.infinity,
          child: FlatButton(
            color: Theme.of(context).primaryColor,
            child: Text("查看答案"),
            onPressed: _pressShowAnswerButton,
          )),
    );
  }

  void _pressOptionsButton(String option) {
    cardService.updateDBCardStatus(displayedCard.key, option);
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
