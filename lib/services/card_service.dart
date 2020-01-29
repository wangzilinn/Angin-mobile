import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/displayed_card_model.dart';
import 'package:word_front_end/models/rest_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:word_front_end/services/config_service.dart';

class CardService {
  static const API = "http://47.103.194.29:8080/";
  static const header = {'Content-Type': "application/json"};

  List<DisplayedCardModel> _cardList;
  int _currentCardIndex;

  ConfigService get configService => GetIt.I<ConfigService>();

  Future<RESTResponseModel<List<DisplayedCardModel>>> getRemoteCardList(
      {@required int reciteCardNumber, @required int newCardNumber}) {
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

  Future<void> updateCardStatus(String key, String option) {
    String url = API + "/updateCardStatus/$key/$option";
    return http.get(url, headers: header).then((data) {
      if (data.statusCode == 200) {
        var utf8decoder = new Utf8Decoder();
        final jsonData = json.decode(utf8decoder.convert(data.bodyBytes));
        DisplayedCardModel displayedCardModel = DisplayedCardModel.fromJson(
            jsonData,
            deadline: configService.settings.deadline);
        //从原始列表中更新新获得的卡片的选项和过期时间.
        _cardList.firstWhere((item) {
          if (item.key == displayedCardModel.key) {
            item.options = displayedCardModel.options;
            item.expirationTime = displayedCardModel.expirationTime;
            return true;
          } else
            return false;
        });
      }
    });
  }

  Future<void> downloadTodayCardList() async {
    var maxNewCardNumber = configService.settings.maxNewCardNumber;
    var maxReciteCardNumber = configService.settings.maxReciteCardNumber;

    bool alreadyFetchedTodayCardList =
        configService.settings.alreadyFetchedTodayCardList;

    if (!alreadyFetchedTodayCardList) {
      _cardList = await getRemoteCardList(
              reciteCardNumber: maxReciteCardNumber,
              newCardNumber: maxNewCardNumber)
          .then((response) {
        if (!response.error) {
          //已经从服务器获取了今天的单词列表,不在从服务器重新获取
          configService.settings.alreadyFetchedTodayCardList = true;
          return response.data;
        } else {
          return null;
        }
      });
    }
  }

  //根据index获得卡片详情
  DisplayedCardModel getCard(int index) {
    _currentCardIndex = index;
    return _cardList[index];
  }

  //获得下一个卡片详情
  DisplayedCardModel next() {
    _currentCardIndex++;
    //如果到底了,则从头开始
    if (_currentCardIndex >= _cardList.length) _currentCardIndex = 0;
    if (_cardList.length == 0)
      return null;
    else
      return _cardList[_currentCardIndex];
  }

  bool get hasDownloadCardList{
    if(_cardList != null)
      return true;
    else
      return false;
  }

  int get listLength => _cardList.length;
}
