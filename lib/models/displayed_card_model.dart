class DisplayedCardModel{
  String key;
  String front;
  String back;
  String expireDate;
  List<String> options;

  DisplayedCardModel({this.key, this.front, this.back, this.expireDate, this.options});

  factory DisplayedCardModel.fromJson(Map<String, dynamic> item){
    List<String> options = new List();//map不能直接赋值
    for(var opt in item['options']){
      options.add(opt);
    }
    return DisplayedCardModel(
      key: item['key'],
      front: item['front'],
      back: item['back'],
      expireDate: item['expireDate'],
      options: options
    );
  }
}