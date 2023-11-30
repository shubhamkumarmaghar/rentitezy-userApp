class SettingsModel {
  final String agreement;

  SettingsModel({
    required this.agreement
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      agreement: json['agreement']
    );
  }
}
