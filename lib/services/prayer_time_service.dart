import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:adhan/adhan.dart';

class PrayerTimeService extends ChangeNotifier {
  DateTime _fajrTime = DateTime.now();
  DateTime _lastThirdTime = DateTime.now();
  Duration _countdown = Duration.zero;
  Timer? _timer;
  bool _autoLocation = true;
  bool _isLoading = true;
  String? _errorMessage;

  DateTime get fajrTime => _fajrTime;
  DateTime get lastThirdTime => _lastThirdTime;
  Duration get countdown => _countdown;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PrayerTimeService() {
    _calculateTimes();
    _startCountdown();
  }

  void updateSettings({required bool autoLocation}) {
    if (_autoLocation != autoLocation) {
      _autoLocation = autoLocation;
      _calculateTimes();
      notifyListeners();
    }
  }

  Future<Position?> _determinePosition() async {
    if (!_autoLocation) return null;

    bool serviceEnabled;
    LocationPermission permission;

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

  Future<List<String>?> _fetchMawaqitTimes(double lat, double lon) async {
    try {
      final uri = Uri.parse(
          'https://mawaqit.net/api/2.0/mosque/search?lat=${lat.toStringAsFixed(4)}&lon=${lon.toStringAsFixed(4)}&take=1&lang=fr');
      
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          final firstMosque = data[0];
          final times = firstMosque['times'] as List<dynamic>?;
          if (times != null) {
             debugPrint('🕌 Mawaqit Mosque: ${firstMosque['name']}');
             return times.map((t) => t.toString()).toList();
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching Mawaqit: $e');
    }
    return null;
  }

  DateTime _parseTime(String hhmm, {DateTime? date}) {
    final base = date ?? DateTime.now();
    final parts = hhmm.split(':');
    return DateTime(
      base.year,
      base.month,
      base.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  Future<void> _calculateTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final position = await _determinePosition();
      
      final double lat = position?.latitude ?? 48.8566;
      final double lon = position?.longitude ?? 2.3522;

      debugPrint('📍 Location: $lat, $lon');

      // 1. Try Mawaqit API
      List<String>? mawaqitTimes = await _fetchMawaqitTimes(lat, lon);

      // 2. Fallback Adhan calc
      final coords = Coordinates(lat, lon);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      
      final now = DateTime.now();
      final prayerTimesToday = PrayerTimes(coords, DateComponents(now.year, now.month, now.day), params);
      final tomorrow = now.add(const Duration(days: 1));
      final prayerTimesTomorrow = PrayerTimes(coords, DateComponents(tomorrow.year, tomorrow.month, tomorrow.day), params);

      DateTime fajrToday;
      DateTime maghribToday;
      DateTime fajrTomorrow;

      if (mawaqitTimes != null && mawaqitTimes.length >= 5) {
        // Mawaqit can return 5 or 6 times.
        // If 6: [Fajr, Shuruq, Dhuhr, Asr, Maghrib, Isha] -> Maghrib at index 4
        // If 5: [Fajr, Dhuhr, Asr, Maghrib, Isha] -> Maghrib at index 3
        if (mawaqitTimes.length >= 6) {
          fajrToday = _parseTime(mawaqitTimes[0]);
          maghribToday = _parseTime(mawaqitTimes[4]);
          debugPrint('✅ Using Mawaqit (6-times system): Fajr ${mawaqitTimes[0]}, Maghrib ${mawaqitTimes[4]}');
        } else {
          fajrToday = _parseTime(mawaqitTimes[0]);
          maghribToday = _parseTime(mawaqitTimes[3]);
          debugPrint('✅ Using Mawaqit (5-times system): Fajr ${mawaqitTimes[0]}, Maghrib ${mawaqitTimes[3]}');
        }
        // For tomorrow's Fajr (needed for night calculation), we approximate with local for now
        // or we assume it's roughly the same.
        fajrTomorrow = prayerTimesTomorrow.fajr;
      } else {
        debugPrint('⚠️ Falling back to local Adhan calculation');
        fajrToday = prayerTimesToday.fajr;
        maghribToday = prayerTimesToday.maghrib;
        fajrTomorrow = prayerTimesTomorrow.fajr;
      }

      _fajrTime = fajrToday;

      // --- Precise Last Third calculation ---
      // We need to find the "next" last third.
      DateTime nightStart;
      DateTime nightEnd;

      if (now.isAfter(maghribToday)) {
        // Current night: Maghrib Today -> Fajr Tomorrow
        nightStart = maghribToday;
        nightEnd = fajrTomorrow;
      } else if (now.isBefore(fajrToday)) {
        // Current night (pre-dawn): Maghrib Yesterday -> Fajr Today
        final yesterday = now.subtract(const Duration(days: 1));
        final prayerTimesYesterday = PrayerTimes(coords, DateComponents(yesterday.year, yesterday.month, yesterday.day), params);
        nightStart = prayerTimesYesterday.maghrib;
        nightEnd = fajrToday;
      } else {
        // Daytime: Upcoming night is Maghrib Today -> Fajr Tomorrow
        nightStart = maghribToday;
        nightEnd = fajrTomorrow;
      }

      final nightDuration = nightEnd.difference(nightStart);
      final lastThird = nightStart.add(Duration(milliseconds: (nightDuration.inMilliseconds * 2 ~/ 3)));
      
      // Safety: If somehow lastThird is in the past, move to next night cycle
      if (lastThird.isBefore(now)) {
        final nightDurationNext = fajrTomorrow.difference(maghribToday);
        _lastThirdTime = maghribToday.add(Duration(milliseconds: (nightDurationNext.inMilliseconds * 2 ~/ 3)));
      } else {
        _lastThirdTime = lastThird;
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error calculating prayer times: $e");
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
        _calculateTimes();
      }
      _countdown = _lastThirdTime.difference(now);
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
