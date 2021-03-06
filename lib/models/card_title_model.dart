import 'package:intl/intl.dart';

import 'card_detail_model.dart';

class CardTitleModel {
  String key;
  DateTime _expirationTime;
  CardStatus status;

  CardTitleModel(String key, DateTime expirationTime, CardStatus status) {
    this.key = key;
    this._expirationTime = expirationTime;
    this.status = status;
  }

  CardTitleModel.fromDetail(CardDetailModel cardDetailModel) {
    this.key = cardDetailModel.key;
    this._expirationTime = cardDetailModel.expirationTime;
    this.status = cardDetailModel.status;
  }

  String get expirationTime {
    return '过期时间:${DateFormat('yyyy-MM-dd HH:mm:ss').format(_expirationTime)}';
  }
}
