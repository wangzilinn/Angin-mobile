class LocalStatusModel{
  bool alreadyFetchedTodayCardList;
  int maxReciteCardNumber;
  int maxNewCardNumber;
  DateTime _deadline;

  LocalStatusModel({this.maxReciteCardNumber, this.maxNewCardNumber}){
    alreadyFetchedTodayCardList = false;
    _deadline = DateTime(1996,11,12,18,0,0,0);
  }

  //获得今日的过期时间,因为可能是之前天数设置的,所以要转换为今天的日子
  DateTime get deadline{
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;

    int hour = _deadline.hour;
    int minute = _deadline.minute;
    int second = _deadline.second;

    _deadline = DateTime(year, month, day, hour, minute, second);
    return _deadline;
  }

  set deadline(DateTime dateTime) {
    _deadline = dateTime;
  }
}