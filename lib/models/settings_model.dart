class SettingsModel {
  final String language;
  final bool alarmEnabled;
  final String ringtone;
  final double volume;
  final String calculationMethod;
  final bool autoLocation;
  final bool darkMode;
  final bool onboardingCompleted;
  final List<int> activeDays; // 1=Monday, 2=Tuesday, ..., 7=Sunday

  SettingsModel({
    this.language = 'fr',
    this.alarmEnabled = true,
    this.ringtone = 'adhan_1',
    this.volume = 0.7,
    this.calculationMethod = 'muslim_world_league',
    this.autoLocation = true,
    this.darkMode = false,
    this.onboardingCompleted = false,
    this.activeDays = const [1, 2, 3, 4, 5, 6, 7], // All days by default
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
    List<int>? activeDays,
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
        activeDays: activeDays ?? this.activeDays,
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
        'activeDays': activeDays,
      };

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        language: json['language'] ?? 'fr',
        alarmEnabled: json['alarmEnabled'] ?? true,
        ringtone: _normalizeRingtone(json['ringtone']),
        volume: (json['volume'] ?? 0.7).toDouble(),
        calculationMethod: json['calculationMethod'] ?? 'muslim_world_league',
        autoLocation: json['autoLocation'] ?? true,
        darkMode: json['darkMode'] ?? false,
        onboardingCompleted: json['onboardingCompleted'] ?? false,
        activeDays: (json['activeDays'] as List<dynamic>?)?.map((e) => e as int).toList() ?? 
                    const [1, 2, 3, 4, 5, 6, 7],
      );

  static String _normalizeRingtone(dynamic value) {
    final v = (value ?? '').toString();
    if (v.isEmpty) return 'adhan_1';
    if (v == 'adhan') return 'adhan_1'; // legacy value
    return v;
  }
}
