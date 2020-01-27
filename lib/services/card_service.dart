import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:word_front_end/models/displayed_card_model.dart';
import 'package:word_front_end/models/rest_response_model.dart';
import 'package:http/http.dart' as http;

class CardService {
  static const API = "http://47.103.194.29:8080/getTodayCards/4/2";
  static const header = {'Content-Type': "application/json"};

  Future<RESTResponseModel<List<DisplayedCardModel>>> getCardList(
  {@required int reciteCardNumber,@required int newCardNumber}) {
    String url = API + "/getTodayCards/$reciteCardNumber/$newCardNumber";
    return http.get(url, headers: header).then((data) {
      if (data.statusCode == 200) {
        var utf8decoder = new Utf8Decoder();
        final jsonData = json.decode(utf8decoder.convert(data.bodyBytes));
        final cards = <DisplayedCardModel>[];
        for (var item in jsonData) {
          DisplayedCardModel displayedCardModel =
              DisplayedCardModel.fromJson(item);
          cards.add(displayedCardModel);
        }
        return RESTResponseModel<List<DisplayedCardModel>>(data: cards);
      }
      return RESTResponseModel<List<DisplayedCardModel>>(
          error: true, errorMessage: "An error occrooed");
    });
  }

  Future<RESTResponseModel<bool>> updateCardStatus() {}
}
