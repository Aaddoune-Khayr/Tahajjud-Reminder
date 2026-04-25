import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:khayr__tahajjud_reminder/services/prayer_time_service.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';

class AlarmService extends ChangeNotifier {
  // Native Android alarm channel
  static const _alarmChannel = MethodChannel('com.khayr.app/alarm');

  // flutter_local_notifications — kept only for permission helpers
  final _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _startupPermissionsRequested = false;
  DateTime? _lastScheduledAt;

  bool _isRinging = false;
  bool get isRinging => _isRinging;
  Timer? _ringingCheckTimer;

  // ── Init ────────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;

    // Timezone setup (still needed for correct DateTime → epoch conversion)
    tz.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
      debugPrint('🕐 Timezone: ${tzInfo.identifier}');
    } catch (_) {
      try {
        tz.setLocalLocation(tz.getLocation('Europe/Paris'));
      } catch (_) {}
    }

    // Initialize flutter_local_notifications for permission dialogs only
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: androidInit));

    _initialized = true;
    await _requestStartupPermissions();
    _startRingingCheck();
    debugPrint('✅ AlarmService initialized');
  }

  void _startRingingCheck() {
    _ringingCheckTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final bool currentlyRinging = await _alarmChannel.invokeMethod('isAlarmRinging') as bool? ?? false;
        if (_isRinging != currentlyRinging) {
          _isRinging = currentlyRinging;
          notifyListeners();
        }
      } catch (e) {
        // Ignore errors
      }
    });
  }

  // ── Sync from providers (called when settings or prayer times change) ───

  Future<void> syncFromProviders({
    required SettingsService settingsService,
    required PrayerTimeService prayerTimeService,
  }) async {
    await init();

    final settings = settingsService.settings;
    if (!settings.alarmEnabled) {
      await cancelAlarm();
      return;
    }

    if (prayerTimeService.isLoading) return;

    final next = prayerTimeService.lastThirdTime;

    // Avoid rescheduling too often (within 5 seconds of same time)
    if (_lastScheduledAt != null &&
        (_lastScheduledAt!.difference(next).inSeconds).abs() < 5) {
      return;
    }

    await scheduleAlarm(
      at: next,
      ringtoneKey: settings.ringtone,
      isEnglish: settings.language == 'en',
    );
  }

  // ── Schedule ────────────────────────────────────────────────────────────

  Future<void> scheduleAlarm({
    required DateTime at,
    required String ringtoneKey,
    required bool isEnglish,
  }) async {
    await init();

    // If time already passed today, push to tomorrow
    final now = DateTime.now();
    DateTime scheduled = at.isBefore(now)
        ? DateTime(at.year, at.month, at.day + 1, at.hour, at.minute)
        : at;

    _lastScheduledAt = scheduled;

    final epochMs = scheduled.millisecondsSinceEpoch;
    debugPrint('⏰ Scheduling native alarm at $scheduled ($epochMs ms)');

    try {
      await _alarmChannel.invokeMethod('scheduleAlarm', {
        'epochMs':     epochMs,
        'ringtoneKey': ringtoneKey,
        'isEnglish':   isEnglish,
      });
      debugPrint('✅ Native alarm scheduled');
    } catch (e) {
      debugPrint('❌ scheduleAlarm error: $e');
    }
  }

  // ── Test notification (plays immediately via foreground service) ─────────

  Future<String> showTestNotification({
    required String ringtoneKey,
    required bool isEnglish,
  }) async {
    await init();

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final granted = await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    final enabled = await androidImpl?.areNotificationsEnabled();
    if (granted == false || enabled == false) return 'permission_denied';

    try {
      await _alarmChannel.invokeMethod('startTestAlarm', {
        'ringtoneKey': ringtoneKey,
        'isEnglish':   isEnglish,
      });
      debugPrint('✅ Test alarm service started');
      return 'sent_custom';
    } catch (e) {
      debugPrint('❌ Test alarm error: $e');
      return 'send_failed:$e';
    }
  }

  // ── Stop test ───────────────────────────────────────────────────────────

  Future<void> stopTestAlarm() async {
    try {
      _isRinging = false;
      notifyListeners();
      await _alarmChannel.invokeMethod('stopAlarmService');
      debugPrint('🛑 Test alarm stopped');
    } catch (e) {
      debugPrint('❌ stopTestAlarm error: $e');
    }
  }

  // ── Cancel ──────────────────────────────────────────────────────────────

  Future<void> cancelAlarm() async {
    await init();
    _lastScheduledAt = null;
    try {
      await _alarmChannel.invokeMethod('cancelAlarm');
      debugPrint('🗑️ Native alarm cancelled');
    } catch (e) {
      debugPrint('❌ cancelAlarm error: $e');
    }
  }

  // ── Battery optimisation ─────────────────────────────────────────────────

  Future<bool> isIgnoringBatteryOptimization() async {
    try {
      return await _alarmChannel.invokeMethod('isIgnoringBatteryOptimization') as bool? ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> requestIgnoreBatteryOptimization() async {
    try {
      await _alarmChannel.invokeMethod('requestIgnoreBatteryOptimization');
    } catch (_) {}
  }

  // ── Permissions ──────────────────────────────────────────────────────────

  Future<bool?> requestPermission() async {
    await init();
    return _requestAllRelevantPermissions();
  }

  Future<void> _requestStartupPermissions() async {
    if (_startupPermissionsRequested) return;
    _startupPermissionsRequested = true;
    await _requestAllRelevantPermissions();
    // Also request battery optimisation exemption on first run
    final ignoring = await isIgnoringBatteryOptimization();
    if (!ignoring) await requestIgnoreBatteryOptimization();
  }

  Future<bool?> _requestAllRelevantPermissions() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();
    return granted;
  }

  Future<Map<String, bool?>> getPermissionDiagnostics() async {
    await init();
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return {
      'notificationsEnabled': await androidImpl?.areNotificationsEnabled(),
      'exactAlarmsEnabled':   await androidImpl?.canScheduleExactNotifications(),
    };
  }
}
