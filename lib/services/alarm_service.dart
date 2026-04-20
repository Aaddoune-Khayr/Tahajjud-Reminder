import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:khayr__tahajjud_reminder/services/prayer_time_service.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';

class AlarmService extends ChangeNotifier {
  static const int _notificationId = 1001;
  static const String _channelName = 'Tahajjud alarm';
  static const String _channelDescription =
      'Tahajjud reminder notification with Adhan sound.';

  static const String actionStop = 'STOP_ALARM';
  static const String actionStopLabelEn = 'Stop';
  static const String actionStopLabelFr = 'Arrêter';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _startupPermissionsRequested = false;
  DateTime? _lastScheduledAt;

  Future<void> init() async {
    if (_initialized) return;

    // 1. Initialize timezones database
    tz.initializeTimeZones();

    // 2. Get local timezone name - FlutterTimezone 5.0.1 returns TimezoneInfo
    try {
      final TimezoneInfo tzInfo = await FlutterTimezone.getLocalTimezone();
      final String tzName = tzInfo.identifier;
      debugPrint('🕐 Setting timezone to: $tzName');
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (e) {
      debugPrint('⚠️ Could not set timezone: $e — using Europe/Paris fallback');
      try {
        tz.setLocalLocation(tz.getLocation('Europe/Paris'));
        debugPrint('🕐 Using Europe/Paris as fallback timezone');
      } catch (_) {}
    }

    // 3. Initialize notifications plugin
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) async {
        if (response.actionId == actionStop) {
          await cancelAlarm();
        }
      },
    );

    _initialized = true;
    await _requestStartupPermissions();
    debugPrint('✅ AlarmService initialized');
  }

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

    // Avoid rescheduling too often (within 5 seconds of same time).
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

  Future<void> scheduleAlarm({
    required DateTime at,
    required String ringtoneKey,
    required bool isEnglish,
    bool isTest = false,
  }) async {
    await init();

    // If the time is in the past (already happened recently), schedule for tomorrow exactly by adding 1 day locally
    final now = DateTime.now();
    DateTime scheduled = at;
    if (at.isBefore(now)) {
      scheduled = DateTime(at.year, at.month, at.day + 1, at.hour, at.minute);
    }
    _lastScheduledAt = scheduled;

    debugPrint('⏰ Scheduling alarm for: $scheduled (tz.local = ${tz.local.name})');

    final tzScheduled = tz.TZDateTime.from(scheduled, tz.local);
    debugPrint('⏰ TZDateTime: $tzScheduled');

    final String currentChannelId = 'tahajjud_alarm_${ringtoneKey}_v4';
    
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(
      AndroidNotificationChannel(
        currentChannelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(ringtoneKey),
        enableVibration: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
    );

    final androidDetails = AndroidNotificationDetails(
      currentChannelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(ringtoneKey),
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      actions: [
        AndroidNotificationAction(
          actionStop,
          isEnglish ? actionStopLabelEn : actionStopLabelFr,
          cancelNotification: true,
        ),
      ],
    );

    final details = NotificationDetails(android: androidDetails);

    final title = 'Tahajjud';
    final body = isTest
        ? (isEnglish
            ? 'Test — tap Stop to silence.'
            : 'Test — appuyez sur Arrêter pour couper.')
        : (isEnglish
            ? 'Time to wake up for Tahajjud 🌙'
            : 'Il est temps de se réveiller pour Tahajjud 🌙');

    await _plugin.zonedSchedule(
      _notificationId,
      title,
      body,
      tzScheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: isTest ? null : DateTimeComponents.time,
    );

    debugPrint('✅ Alarm scheduled at $tzScheduled');
  }

  /// Affiche une notification de test IMMÉDIATEMENT.
  Future<void> showTestNotification({
    required String ringtoneKey,
    required bool isEnglish,
  }) async {
    await init();

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final notificationsGranted =
        await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    if (notificationsGranted == false) {
      throw Exception('Notification permission denied');
    }

    debugPrint('🔔 Showing test notification now...');

    // Keep test channel simple to avoid device-specific issues with custom
    // alarm channels while debugging notification delivery.
    const String currentChannelId = 'test_channel_basic_v1';

    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        currentChannelId,
        'Alertes de test',
        description: 'Canal pour les tests de notification',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ),
    );

    const androidDetails = AndroidNotificationDetails(
      currentChannelId,
      'Alertes de test',
      channelDescription: 'Canal pour les tests de notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const details = NotificationDetails(android: androidDetails);

    final title = 'Test Khayr 🌙';
    final body = isEnglish
        ? 'Test notif — alarm works correctly!'
        : 'Notif test — l\'alarme fonctionne correctement !';

    await _plugin.show(999, title, body, details, payload: 'test');
    debugPrint('✅ Test notification shown');
  }

  Future<bool?> requestPermission() async {
    await init();
    return _requestAllRelevantPermissions();
  }

  Future<void> _requestStartupPermissions() async {
    if (_startupPermissionsRequested) return;
    _startupPermissionsRequested = true;
    await _requestAllRelevantPermissions();
  }

  Future<bool?> _requestAllRelevantPermissions() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final notificationsGranted =
        await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    return notificationsGranted;
  }

  Future<void> cancelAlarm() async {
    await init();
    _lastScheduledAt = null;
    await _plugin.cancel(_notificationId);
    debugPrint('🗑️ Alarm cancelled');
  }
}
