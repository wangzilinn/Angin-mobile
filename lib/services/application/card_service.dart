import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/card_detail_model.dart';
import 'package:word_front_end/models/card_title_model.dart';
import 'package:word_front_end/models/data_request_model.dart';
import 'package:word_front_end/models/data_response_model.dart';
import 'package:word_front_end/services/application/user_service.dart';
import 'package:word_front_end/services/platform/http_service.dart';
import 'package:word_front_end/services/platform/storage_service.dart';
import 'package:word_front_end/views/card/card_delete_view.dart';

class CardService {
  UserService get configService => GetIt.I<UserService>();

  StorageService get storageService => GetIt.I<StorageService>();

  HttpService get httpService => GetIt.I<HttpService>();

  UserService get userService => GetIt.I<UserService>();

  static const CARD_LIST_FILE_NAME = "card_list";

  List<CardDetailModel> _cardList;
  int _currentCardIndex;
  String userId;
  String password;

  CardService() {
    userId = userService.settings["userId"];
    password = userService.settings["password"];
  }


  //从网络获得今日背单词列表
  Future<DataResponseModel<List<CardDetailModel>>> _getDBCardList(
      {@required int reciteCardNumber, @required int newCardNumber}) {
    String api = "/card/todayCards";
    Map params = {"expiredLimit": reciteCardNumber, "newLimit": newCardNumber};
    var requestBody =
        DataRequestModel(userId, password, additionalData: params);
    return httpService.post(api, body: requestBody).then((data) {
      if (data.statusCode == 200) {
        var utf8decoder = new Utf8Decoder();
        final jsonData = jsonDecode(
            utf8decoder.convert(data.bodyBytes)); //change from json.decode
        final cards = <CardDetailModel>[];
        for (var item in jsonData) {
          CardDetailModel displayedCardModel = CardDetailModel.fromJson(item);
          cards.add(displayedCardModel);
        }
        return DataResponseModel<List<CardDetailModel>>(data: cards);
      }
      return DataResponseModel<List<CardDetailModel>>(
          error: true, errorMessage: "Load Card list failed");
    });
  }

  //更新卡片状态
  Future<void> updateDBCardStatus(String key, String option) {
    var index = _currentCardIndex; //先获得索引, 防止异步函数等待回调期间索引改变
    String api = "/card/cardStatus";
    Map params = {"key": key, "status": option};
    var requestBody = DataRequestModel(
        userId, password, additionalData: params);
    return httpService.post(api, body: requestBody).then((data) {
      if (data.statusCode == 200) {
        var utf8decoder = new Utf8Decoder();
        final jsonData = json.decode(utf8decoder.convert(data.bodyBytes));
        CardDetailModel displayedCardModel = CardDetailModel.fromJson(jsonData,
            deadline: configService.settings["deadline"]);
        //从原始列表中更新新获得的卡片的选项和过期时间.
        assert(_cardList[index].key == displayedCardModel.key);
        //判断这个卡片是不是超出了当日过期时间,超过则从列表中删除
        if (displayedCardModel.status == CardStatus.DONE) {
          _cardList.removeAt(index);
          _currentCardIndex--; //由于删除了当前的,所以要把指针向上移动一个,来使详情页中的下一个为没删除时的下一个
        } else {
          _cardList[index].options = displayedCardModel.options;
          _cardList[index].expirationTime = displayedCardModel.expirationTime;
          _cardList[index].status = displayedCardModel.status;
        }
        _saveCardList();
      }
    });
  }

  //更新卡片内容
  Future<void> updateCardDetails(CardDetailModel cardDetailModel) {
    var index = _currentCardIndex; //先获得索引, 防止异步函数等待回调期间索引改变(其实这里用不着,不过以防万一
    String api = "/card/cardDetail";
    //先更新本地列表
    assert(_cardList[index].key == cardDetailModel.key);
    _cardList[index].front = cardDetailModel.front;
    _cardList[index].back = cardDetailModel.back;
    //再更新数据库
    Map<String, dynamic> cardDetailJson = cardDetailModel.outlineToJson();
    var requestBody = DataRequestModel(
        userId, password, additionalData: cardDetailJson);
    return httpService.put(api, body: requestBody).then((data) {
      if (data.statusCode == 200) {
        print('update detail Successfully');
      } else {
        print("update detail failed");
      }
    });
  }

  //删除指定卡片
  Future<void> _deleteDBCard(String key) {
    String api = "/card";
    Map<String, dynamic> params = {"key": key};
    var requestBody = DataRequestModel(
        userId, password, additionalData: params);
    return httpService.delete(api).then((data) {
      if (data.statusCode == 200) {
        print('delete Successfully');
      } else {
        print("delete failed");
      }
    });
  }

  Future<void> fetchTodayCardList() async {
    var maxNewCardNumber = configService.settings["maxNewCardNumber"];
    var maxReciteCardNumber = configService.settings["maxReciteCardNumber"];

    bool alreadyFetchedTodayCardList =
    configService.settings["alreadyFetchedTodayCardList"];

    if (!alreadyFetchedTodayCardList) {
      print("从服务器拉取数据");
      _cardList = await _getDBCardList(
          reciteCardNumber: maxReciteCardNumber,
          newCardNumber: maxNewCardNumber)
          .then((response) {
        if (!response.error) {
          //已经从服务器获取了今天的单词列表,不在从服务器重新获取
          configService.settings["alreadyFetchedTodayCardList"] = true;
          return response.data;
        } else {
          print("未能获取服务器数据");
          return null;
        }
      });
      _saveCardList();
    } else {
      //如果本地已经有数据了
      print("从本地拉取数据");
      _cardList = await _readLocalCardList();
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

  void _saveCardList() {
    String json = jsonEncode(_cardList);
    print("save list" + json);
    storageService.writeFile(CARD_LIST_FILE_NAME, json);
  }

  Future<List<CardDetailModel>> _readLocalCardList() async {
//    String st = r'[{"key":"exact","front":"\"\"<br/> The exact locations are being kept secret for reasons of security.&nbsp;\"\" <br/>Root:<br/>ex-, 外。-act, 做，驱使，称量，词源同act, examine, exigent. 即称量的，精确要求的。\"","back":"\"adj.准的，精密的；精确的vt.要求；强求；急需vi.勒索钱财<div><span style=\"\"color: rgb(255, 255, 255)\"\">确切地点因为安全原因要保密。</span></div>\"","expireDate":"2020-02-03 18:42:49","options":["一点没印象","没啥印象"]}]';

    final jsonString = await storageService.readFile(CARD_LIST_FILE_NAME);
    final jsonData = json.decode(jsonString);
    final cards = <CardDetailModel>[];
    for (var item in jsonData) {
      CardDetailModel displayedCardModel = CardDetailModel.fromJson(item);
      cards.add(displayedCardModel);
    }
    return cards;
  }
}
