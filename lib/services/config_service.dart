import 'package:word_front_end/models/settings_model.dart';

class ConfigService {
  SettingsModel _savedSettingsModel;

  ConfigService() {
    //TODO 获取本地配置
    _savedSettingsModel =
        new SettingsModel(maxNewCardNumber: 2, maxReciteCardNumber: 4);
  }

  void updateSettings(SettingsModel settingsModel){
    _savedSettingsModel.update(settingsModel);
  }

  SettingsModel get savedSettings => _savedSettingsModel;

  int get maxReciteCardNumber => _savedSettingsModel.maxReciteCardNumber;
  int get maxNewCardNumber => _savedSettingsModel.maxNewCardNumber;
}
