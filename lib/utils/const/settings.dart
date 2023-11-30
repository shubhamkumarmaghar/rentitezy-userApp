import 'package:flutter/material.dart';
import 'package:rentitezy/model/settings_model.dart';

class Settings {
  static String agreement = '';

  void init(BuildContext context, SettingsModel settingsModel) {
    agreement = settingsModel.agreement;
  }

  String getAggrement() {
    String agree = agreement;
    return agree;
  }
}
