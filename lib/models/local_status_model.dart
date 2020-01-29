class LocalStatusModel{
  bool alreadyFetchedTodayCardList;
  int maxReciteCardNumber;
  int maxNewCardNumber;

  LocalStatusModel({this.maxReciteCardNumber, this.maxNewCardNumber}){
    alreadyFetchedTodayCardList = false;
  }
}