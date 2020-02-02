import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/card_detail_model.dart';
import 'package:word_front_end/models/card_title_model.dart';
import 'package:word_front_end/models/rest_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:word_front_end/services/config_service.dart';
import 'package:word_front_end/views/card/card_delete_view.dart';

class CardService {
  static const API = "http://47.103.194.29:8080/";
  static const header = {'Content-Type': "application/json"};

  List<CardDetailModel> _cardList;
  int _currentCardIndex;

  ConfigService get configService => GetIt.I<ConfigService>();

  Future<RESTResponseModel<List<CardDetailModel>>> _getDBCardList(
      {@required int reciteCardNumber, @required int newCardNumber}) {
    String url = API + "/getTodayCards/$reciteCardNumber/$newCardNumber";
    return http.get(url, headers: header).then((data) {
      if (data.statusCode == 200) {
        var utf8decoder = new Utf8Decoder();
        final jsonData = json.decode(utf8decoder.convert(data.bodyBytes));
        final cards = <CardDetailModel>[];
        for (var item in jsonData) {
          CardDetailModel displayedCardModel = CardDetailModel.fromJson(item);
          cards.add(displayedCardModel);
        }
        return RESTResponseModel<List<CardDetailModel>>(data: cards);
      }
      return RESTResponseModel<List<CardDetailModel>>(
          error: true, errorMessage: "An error occrooed");
    });
  }

  Future<void> updateDBCardStatus(String key, String option) {
    String url = API + "/updateCardStatus/$key/$option";
    return http.get(url, headers: header).then((data) {
      if (data.statusCode == 200) {
        var utf8decoder = new Utf8Decoder();
        final jsonData = json.decode(utf8decoder.convert(data.bodyBytes));
        CardDetailModel displayedCardModel = CardDetailModel.fromJson(jsonData,
            deadline: configService.settings.deadline);
        //从原始列表中更新新获得的卡片的选项和过期时间.
        assert(_cardList[_currentCardIndex].key == displayedCardModel.key);
        //判断这个卡片是不是超出了当日过期时间,超过则从列表中删除
        if (displayedCardModel.status == CardStatus.DONE) {
          _cardList.removeAt(_currentCardIndex);
          _currentCardIndex--; //由于删除了当前的,所以要把指针向上移动一个,来使详情页中的下一个为没删除时的下一个
        } else {
          _cardList[_currentCardIndex].options = displayedCardModel.options;
          _cardList[_currentCardIndex].expirationTime =
              displayedCardModel.expirationTime;
          _cardList[_currentCardIndex].status = displayedCardModel.status;
        }
      }
    });
  }

  Future<void> updateCardDetails(CardDetailModel cardDetailModel) {
    String url = API + "/updateCardDetail/${cardDetailModel.key}";
    //先更新本地列表
    assert(_cardList[_currentCardIndex].key == cardDetailModel.key);
    _cardList[_currentCardIndex].front = cardDetailModel.front;
    _cardList[_currentCardIndex].back = cardDetailModel.back;
    //再更新数据库
    Map<String, dynamic> cardDetailJson = cardDetailModel.toJson;
    String body = json.encode(cardDetailJson);
    return http.put(url, headers: header, body: body).then((data) {
      if (data.statusCode == 200) {
        print('update detail Successfully');
      } else {
        print("update detail failed");
      }
    });
  }

  Future<void> _deleteDBCard(String key) {
    String url = API + "/deleteCard/$key";
    return http.delete(url, headers: header).then((data) {
      if (data.statusCode == 200) {
        print('delete Successfully');
      } else {
        print("delete failed");
      }
    });
  }

  Future<void> downloadTodayCardList() async {
    var maxNewCardNumber = configService.settings.maxNewCardNumber;
    var maxReciteCardNumber = configService.settings.maxReciteCardNumber;

    bool alreadyFetchedTodayCardList =
        configService.settings.alreadyFetchedTodayCardList;

    if (!alreadyFetchedTodayCardList) {
      _cardList = await _getDBCardList(
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

  //根据index获得卡片详情,并记录是从哪里点进去的
  CardDetailModel getCardDetail(int index) {
    _currentCardIndex = index;
    return _cardList[index];
  }

  CardTitleModel getCardTitle(int index) {
    return new CardTitleModel.fromDetail(_cardList[index]);
  }

  //获得下一个卡片详情
  CardDetailModel next() {
    _currentCardIndex++;
    //如果到底了,则从头开始
    if (_currentCardIndex >= _cardList.length) _currentCardIndex = 0;
    if (_cardList.length == 0)
      return null;
    else
      return _cardList[_currentCardIndex];
  }

  bool get hasDownloadCardList {
    if (_cardList != null)
      return true;
    else
      return false;
  }

  int get listLength => _cardList.length;

  void deleteOneCard(int index, DeleteOption deleteOption) {
    _cardList.removeAt(index);
    if (deleteOption == DeleteOption.Permanently) {
      _deleteDBCard(_cardList[index].key);
    }
  }
}
