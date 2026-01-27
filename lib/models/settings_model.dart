class SettingsModel {
  final String language;
  final bool alarmEnabled;
  final String ringtone;
  final double volume;
  final String calculationMethod;
  final bool autoLocation;
  final bool darkMode;
  final bool onboardingCompleted;

  SettingsModel({
    this.language = 'fr',
    this.alarmEnabled = true,
    this.ringtone = 'adhan',
    this.volume = 0.7,
    this.calculationMethod = 'muslim_world_league',
    this.autoLocation = true,
    this.darkMode = false,
    this.onboardingCompleted = false,
  });

  SettingsModel copyWith({
    String? language,
    bool? alarmEnabled,
    String? ringtone,
    double? volume,
    String? calculationMethod,
    bool? autoLocation,
    bool? darkMode,
    bool? onboardingCompleted,
  }) =>
      SettingsModel(
        language: language ?? this.language,
        alarmEnabled: alarmEnabled ?? this.alarmEnabled,
        ringtone: ringtone ?? this.ringtone,
        volume: volume ?? this.volume,
        calculationMethod: calculationMethod ?? this.calculationMethod,
        autoLocation: autoLocation ?? this.autoLocation,
        darkMode: darkMode ?? this.darkMode,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      );

  Map<String, dynamic> toJson() => {
        'language': language,
        'alarmEnabled': alarmEnabled,
        'ringtone': ringtone,
        'volume': volume,
        'calculationMethod': calculationMethod,
        'autoLocation': autoLocation,
        'darkMode': darkMode,
        'onboardingCompleted': onboardingCompleted,
      };

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        language: json['language'] ?? 'fr',
        alarmEnabled: json['alarmEnabled'] ?? true,
        ringtone: json['ringtone'] ?? 'adhan',
        volume: (json['volume'] ?? 0.7).toDouble(),
        calculationMethod: json['calculationMethod'] ?? 'muslim_world_league',
        autoLocation: json['autoLocation'] ?? true,
        darkMode: json['darkMode'] ?? false,
        onboardingCompleted: json['onboardingCompleted'] ?? false,
      );
}
