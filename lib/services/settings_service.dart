import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:khayr__tahajjud_reminder/models/settings_model.dart';

class SettingsService extends ChangeNotifier {
  static const String _settingsKey = 'app_settings';
  SettingsModel _settings = SettingsModel();

  SettingsModel get settings => _settings;

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      if (settingsJson != null) {
        _settings = SettingsModel.fromJson(jsonDecode(settingsJson));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> updateSettings(SettingsModel newSettings) async {
    try {
      _settings = newSettings;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_settingsKey, jsonEncode(_settings.toJson()));
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  Future<void> updateLanguage(String language) async {
    await updateSettings(_settings.copyWith(language: language));
  }

  Future<void> toggleAlarm(bool enabled) async {
    await updateSettings(_settings.copyWith(alarmEnabled: enabled));
  }

  Future<void> updateRingtone(String ringtone) async {
    await updateSettings(_settings.copyWith(ringtone: ringtone));
  }

  Future<void> updateVolume(double volume) async {
    await updateSettings(_settings.copyWith(volume: volume));
  }

  Future<void> updateCalculationMethod(String method) async {
    await updateSettings(_settings.copyWith(calculationMethod: method));
  }

  Future<void> toggleAutoLocation(bool enabled) async {
    await updateSettings(_settings.copyWith(autoLocation: enabled));
  }

  Future<void> toggleDarkMode(bool enabled) async {
    await updateSettings(_settings.copyWith(darkMode: enabled));
  }

  Future<void> updateActiveDays(List<int> days) async {
    await updateSettings(_settings.copyWith(activeDays: days));
  }

   Future<void> completeOnboarding() async {
     await updateSettings(_settings.copyWith(onboardingCompleted: true));
   }
}
