import 'package:word_front_end/models/local_status_model.dart';

class ConfigService {
  //储存所有本地配置
  LocalStatusModel _localStatusModel;

  ConfigService() {
    //TODO 获取本地配置
    _localStatusModel = new LocalStatusModel(maxNewCardNumber: 1, maxReciteCardNumber: 4);
  }

  void updateSettings(
      {int maxReciteCardNumber,
      int maxNewCardNumber,
      bool alreadyFetchedTodayCardList}) {
    if (maxReciteCardNumber != null) {
      _localStatusModel.maxNewCardNumber = maxReciteCardNumber;
    }
    if (maxNewCardNumber != null) {
      _localStatusModel.maxNewCardNumber = maxNewCardNumber;
    }
    if (alreadyFetchedTodayCardList != null) {
      _localStatusModel.alreadyFetchedTodayCardList =
          alreadyFetchedTodayCardList;
    }
    _saveLocalStatusModel();
  }
  LocalStatusModel get settings => _localStatusModel;

  void _saveLocalStatusModel(){
    //TODO 将配置保存到本地
  }
}
