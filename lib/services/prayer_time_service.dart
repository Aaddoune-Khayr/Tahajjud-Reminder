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
  Timer? _recalcTimer;
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
    // Recalculate every hour to stay fresh
    _recalcTimer = Timer.periodic(const Duration(hours: 1), (_) {
      _calculateTimes();
    });
  }

  void updateSettings({required bool autoLocation}) {
    if (_autoLocation != autoLocation) {
      _autoLocation = autoLocation;
      _calculateTimes();
    }
  }

  Future<Position?> _determinePosition() async {
    if (!_autoLocation) return null;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Services de localisation désactivés.';
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Permission de localisation refusée.';
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Permission de localisation refusée définitivement.';
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      debugPrint('📍 Location error: $e');
      return null;
    }
  }

  /// Parse "HH:mm" string into a DateTime for the given date (or today).
  DateTime _parseTime(String hhmm, {DateTime? date}) {
    final base = date ?? DateTime.now();
    final parts = hhmm.split(':');
    if (parts.length < 2) throw FormatException('Invalid time format: $hhmm');
    return DateTime(
      base.year, base.month, base.day,
      int.parse(parts[0]), int.parse(parts[1]),
    );
  }

  /// Fetch prayer times from Mawaqit for a given [date].
  /// Returns [Fajr, Shuruq, Dhuhr, Asr, Maghrib, Isha] strings, or null on failure.
  Future<List<String>?> _fetchMawaqitTimes(double lat, double lon) async {
    try {
      final uri = Uri.parse(
        'https://mawaqit.net/api/2.0/mosque/search'
        '?lat=${lat.toStringAsFixed(4)}'
        '&lon=${lon.toStringAsFixed(4)}'
        '&take=1'
        '&lang=fr',
      );

      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          final mosque = data[0] as Map<String, dynamic>;
          final times = mosque['times'];
          if (times is List && times.length >= 5) {
            final timeList = times.map((t) => t.toString()).toList();
            debugPrint('🕌 Mawaqit: ${mosque['name']}, times: $timeList');
            return timeList;
          }
        }
      } else {
        debugPrint('⚠️ Mawaqit HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Mawaqit fetch error: $e');
    }
    return null;
  }

  Future<void> _calculateTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final position = await _determinePosition();
      final double lat = position?.latitude ?? 48.8566; // Paris fallback
      final double lon = position?.longitude ?? 2.3522;
      final now = DateTime.now();

      // --- 1. Fetch Mawaqit (Primary) or Adhan (Fallback) ---
      final mawaqitTimes = await _fetchMawaqitTimes(lat, lon);
      
      // Helper function to get times for ANY day
      Future<Map<String, DateTime>> _getTimes(DateTime date) async {
        if (mawaqitTimes != null) {
          final hasShuruq = mawaqitTimes.length >= 6;
          return {
            'fajr': _parseTime(mawaqitTimes[0], date: date),
            'maghrib': _parseTime(hasShuruq ? mawaqitTimes[4] : mawaqitTimes[3], date: date),
          };
        } else {
          final coords = Coordinates(lat, lon);
          // Define UOIF (12 degrees) as default for France, which prevents large offsets
          // when Mawaqit API is unavailable or doesn't match the specific selected mosque.
          final params = CalculationMethod.other.getParameters();
          params.fajrAngle = 12.0;
          params.ishaAngle = 12.0;
          params.madhab = Madhab.shafi;
          final adhan = PrayerTimes(coords, DateComponents.from(date), params);
          return {
            'fajr': adhan.fajr.toLocal(),
            'maghrib': adhan.maghrib.toLocal(),
          };
        }
      }

      final today = await _getTimes(now);
      final yesterday = await _getTimes(now.subtract(const Duration(days: 1)));
      final tomorrow = await _getTimes(now.add(const Duration(days: 1)));

      _fajrTime = today['fajr']!;

      // --- 2. Calculate Last Third Windows ---
      DateTime _calcLastThird(DateTime maghrib, DateTime fajrNextDay) {
        final duration = fajrNextDay.difference(maghrib);
        return maghrib.add(Duration(milliseconds: (duration.inMilliseconds * 2 ~/ 3)));
      }

      final lastThirdWindow1 = _calcLastThird(yesterday['maghrib']!, today['fajr']!);
      final lastThirdWindow2 = _calcLastThird(today['maghrib']!, tomorrow['fajr']!);

      // --- 3. Selection: Which one is next? ---
      if (now.isBefore(lastThirdWindow1)) {
        _lastThirdTime = lastThirdWindow1;
      } else {
        _lastThirdTime = lastThirdWindow2;
      }

      debugPrint('🌙 Fajr: ${today['fajr']}');
      debugPrint('🌙 Maghrib: ${today['maghrib']}');
      debugPrint('🌙 Target Last Third: $_lastThirdTime');

      _errorMessage = null;
    } catch (e, stack) {
      _errorMessage = e.toString();
      debugPrint('❌ Error calculating times: $e\n$stack');
      final now = DateTime.now();
      _fajrTime = DateTime(now.year, now.month, now.day, 6, 0);
      _lastThirdTime = DateTime(now.year, now.month, now.day, 3, 30);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      _countdown = _lastThirdTime.difference(now);
      if (_countdown.isNegative) _countdown = Duration.zero;
      notifyListeners();
    });
  }

  String formatCountdown() {
    final h = _countdown.inHours;
    final m = _countdown.inMinutes % 60;
    final s = _countdown.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recalcTimer?.cancel();
    super.dispose();
  }
}
