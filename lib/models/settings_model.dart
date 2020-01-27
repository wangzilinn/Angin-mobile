class SettingsModel {
  int maxReciteCardNumber;
  int maxNewCardNumber;

  SettingsModel({this.maxReciteCardNumber, this.maxNewCardNumber});

  void update(SettingsModel settingsModel) {
    this.maxReciteCardNumber =
        settingsModel.maxReciteCardNumber ?? this.maxReciteCardNumber;
    this.maxNewCardNumber =
        settingsModel.maxNewCardNumber ?? this.maxNewCardNumber;
  }
}
