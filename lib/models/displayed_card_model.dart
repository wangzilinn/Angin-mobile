enum CardStatus { READY, SUSPEND, DONE }

class DisplayedCardModel {
  String key;
  String front;
  String back;
  DateTime expirationTime;
  List<String> options;
  CardStatus status;

  DisplayedCardModel({this.key,
    this.front,
    this.back,
    this.expirationTime,
    this.options,
    this.status});

  factory DisplayedCardModel.fromJson(Map<String, dynamic> item,
      {DateTime deadline}) {

    //处理options:
    List<String> options = new List(); //map不能直接赋值
    for (var opt in item['options']) {
      options.add(opt);
    }

    //处理卡片状态:
    DateTime expirationTime = DateTime.parse(item['expireDate']);
    CardStatus cardStatus;
    //获得当前卡片的状态:
    if (deadline != null) {
      if (expirationTime.isBefore(DateTime.now()))
        cardStatus = CardStatus.READY;
      else if (expirationTime.isBefore(deadline))
        cardStatus = CardStatus.SUSPEND;
      else
        cardStatus = CardStatus.DONE;
    } else {//如果没传入当日死线,说明是首次获得卡片信息,则肯定是要背的
      cardStatus = CardStatus.READY;
    }

    return DisplayedCardModel(
        key: item['key'],
        front: item['front'],
        back: item['back'],
        expirationTime: expirationTime,
        options: options,
        status: cardStatus);
  }
}
