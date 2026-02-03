import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';

class PrayerTimeService extends ChangeNotifier {
  DateTime _fajrTime = DateTime.now();
  DateTime _lastThirdTime = DateTime.now();
  Duration _countdown = Duration.zero;
  Timer? _timer;
  String _calculationMethod = 'muslim_world_league';
  bool _autoLocation = true;
  bool _isLoading = true;
  String? _errorMessage;

  DateTime get fajrTime => _fajrTime;
  DateTime get lastThirdTime => _lastThirdTime;
  Duration get countdown => _countdown;
  String get calculationMethod => _calculationMethod;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PrayerTimeService() {
    _calculateTimes();
    _startCountdown();
  }

  void updateSettings({required String method, required bool autoLocation}) {
    bool changed = false;
    if (_calculationMethod != method) {
      _calculationMethod = method;
      changed = true;
    }
    if (_autoLocation != autoLocation) {
      _autoLocation = autoLocation;
      changed = true;
    }
    
    if (changed) {
      _calculateTimes();
      notifyListeners();
    }
  }

  Future<Position?> _determinePosition() async {
    if (!_autoLocation) return null;

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _errorMessage = 'Location services are disabled.';
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _errorMessage = 'Location permissions are denied';
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _errorMessage =
          'Location permissions are permanently denied, we cannot request permissions.';
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  CalculationMethod _getAdhanMethod(String method) {
    switch (method) {
      case 'isna':
        return CalculationMethod.north_america;
      case 'egypt':
        return CalculationMethod.egyptian;
      case 'muslim_world_league':
      default:
        return CalculationMethod.muslim_world_league;
    }
  }

  Future<void> _calculateTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final position = await _determinePosition();
      
      // Default fallback (Paris) if location fails
      final coords = position != null
          ? Coordinates(position.latitude, position.longitude)
          : Coordinates(48.8566, 2.3522); 

      debugPrint('📍 Location used: ${coords.latitude}, ${coords.longitude} (Auto: $_autoLocation)');

      final params = _getAdhanMethod(_calculationMethod).getParameters();
      params.madhab = Madhab.shafi;

      final now = DateTime.now();
      final todayDate = DateComponents(now.year, now.month, now.day);
      
      // Calculate Prayer Times for Today
      final prayerTimesToday = PrayerTimes(coords, todayDate, params);
      
      debugPrint('🕌 Fajr Today: ${prayerTimesToday.fajr} | Maghrib Today: ${prayerTimesToday.maghrib}');
      
      // Determine Maghrib (Sunset start of night) and Fajr (End of night)
      DateTime maghribToday = prayerTimesToday.maghrib;
      DateTime fajrToday = prayerTimesToday.fajr;

      // Ensure Fajr is for the *next* ending transition relative to the night starting at Maghrib
      // Case 1: Before Maghrib today. The "upcoming night" is Maghrib Today -> Fajr Tomorrow.
      // Case 2: After Maghrib today (during the night). The current night ends at Fajr Tomorrow.
      // Typically: Night = Maghrib(Day N) to Fajr(Day N+1)
      
      // But we need "Next Last Third".
      
      // Let's look at a simpler cycle:
      // We need the next occurrence of the "Last Third".
      // Is it tonight? Or tomorrow night?
      
      // Let's calculate for "Tonight's night" (Maghrib Today -> Fajr Tomorrow)
      // and "Yesterday's night" (Maghrib Yesterday -> Fajr Today) - relevant if we are currently in the early morning (before Fajr).
      
      // Simplification: Calculate "Next Last Third" dynamically.
      // 1. Calculate potential Last Third for "Yesterday->Today", "Today->Tomorrow".
      // 2. Pick the first one that is in the future.

      DateTime? validLastThird;
      
      // Check Night 1: Yesterday Maghrib -> Today Fajr
      // (Relevant if we are at 2 AM)
      final yesterday = now.subtract(const Duration(days: 1));
      final prayerTimesYesterday = PrayerTimes(coords, DateComponents(yesterday.year, yesterday.month, yesterday.day), params);
      
      final maghribYest = prayerTimesYesterday.maghrib;
      final fajrTodayCalc = prayerTimesToday.fajr; // Fajr of "Today" is end of yesterday's night
      
      final nightDurationYest = fajrTodayCalc.difference(maghribYest);
      final lastThirdStartYest = maghribYest.add(Duration(milliseconds: (nightDurationYest.inMilliseconds * 2 / 3).round()));
      
      if (lastThirdStartYest.isAfter(now)) {
        validLastThird = lastThirdStartYest;
        _fajrTime = fajrTodayCalc;
      }
      
      // Check Night 2: Today Maghrib -> Tomorrow Fajr
      if (validLastThird == null) {
         final tomorrow = now.add(const Duration(days: 1));
         final prayerTimesTomorrow = PrayerTimes(coords, DateComponents(tomorrow.year, tomorrow.month, tomorrow.day), params);
         
         final maghribTodayCalc = prayerTimesToday.maghrib;
         final fajrTomorrowCalc = prayerTimesTomorrow.fajr;
         
         final nightDurationToday = fajrTomorrowCalc.difference(maghribTodayCalc);
         final lastThirdStartToday = maghribTodayCalc.add(Duration(milliseconds: (nightDurationToday.inMilliseconds * 2 / 3).round()));
         
         validLastThird = lastThirdStartToday;
         _fajrTime = fajrTomorrowCalc;
      }

      _lastThirdTime = validLastThird!;
      
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Error calculating prayer times: $e");
      // Fallback safe defaults just in case
      _lastThirdTime = DateTime.now().add(const Duration(hours: 1));
      _fajrTime = DateTime.now().add(const Duration(hours: 2));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (_lastThirdTime.isBefore(now)) {
        // If the target time passed, recalculate for the next cycle
        _calculateTimes();
      }
      _countdown = _lastThirdTime.difference(now);
      // Prevent negative countdowns
      if (_countdown.isNegative) _countdown = Duration.zero;
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
