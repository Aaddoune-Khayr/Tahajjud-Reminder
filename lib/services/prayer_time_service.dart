import 'dart:async';
import 'package:flutter/foundation.dart';

class PrayerTimeService extends ChangeNotifier {
  DateTime _fajrTime = DateTime.now().copyWith(hour: 5, minute: 30, second: 0);
  DateTime _lastThirdTime = DateTime.now().copyWith(hour: 3, minute: 45, second: 0);
  Duration _countdown = Duration.zero;
  Timer? _timer;
  String _calculationMethod = 'muslim_world_league';

  DateTime get fajrTime => _fajrTime;
  DateTime get lastThirdTime => _lastThirdTime;
  Duration get countdown => _countdown;
  String get calculationMethod => _calculationMethod;

  PrayerTimeService() {
    _calculateTimes();
    _startCountdown();
  }

  /// Update calculation method (MWL / ISNA / Egypt) and recalculate times.
  ///
  /// This simulates different Fajr times depending on the chosen method.
  void updateCalculationMethod(String method) {
    _calculationMethod = method;
    _calculateTimes();
    notifyListeners();
  }

  void _calculateTimes() {
    final now = DateTime.now();
    // Simuler l'heure du Fajr en fonction de la méthode choisie
    // MWL – Standard Europe
    // ISNA – Amérique du Nord (Fajr un peu plus tard)
    // Égypte – Pays arabes (Fajr plus tôt)
    if (_calculationMethod == 'isna') {
      _fajrTime = DateTime(now.year, now.month, now.day, 6, 0);
    } else if (_calculationMethod == 'egypt') {
      _fajrTime = DateTime(now.year, now.month, now.day, 5, 0);
    } else {
      // muslim_world_league
      _fajrTime = DateTime(now.year, now.month, now.day, 5, 30);
    }
    if (_fajrTime.isBefore(now)) {
      _fajrTime = _fajrTime.add(const Duration(days: 1));
    }

    // Calculer l'heure du coucher du soleil (approximation : 18h30)
    final sunset = DateTime(now.year, now.month, now.day, 18, 30);
    
    // Calculer le dernier tiers de la nuit
    // Nuit = du coucher du soleil au Fajr
    final nextFajr = _fajrTime;
    final nightDuration = nextFajr.difference(sunset);
    final lastThirdStart = sunset.add(Duration(
      milliseconds: (nightDuration.inMilliseconds * 2 / 3).round(),
    ));

    _lastThirdTime = lastThirdStart;
    if (_lastThirdTime.isBefore(now)) {
      // Calculer pour le jour suivant
      final tomorrowSunset = sunset.add(const Duration(days: 1));
      final tomorrowFajr = _fajrTime.add(const Duration(days: 1));
      final tomorrowNightDuration = tomorrowFajr.difference(tomorrowSunset);
      _lastThirdTime = tomorrowSunset.add(Duration(
        milliseconds: (tomorrowNightDuration.inMilliseconds * 2 / 3).round(),
      ));
    }

    notifyListeners();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (_lastThirdTime.isBefore(now)) {
        _calculateTimes();
      }
      _countdown = _lastThirdTime.difference(now);
      notifyListeners();
    });
  }

  String formatCountdown() {
    final hours = _countdown.inHours;
    final minutes = _countdown.inMinutes % 60;
    final seconds = _countdown.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
