import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:khayr__tahajjud_reminder/services/prayer_time_service.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';

class AlarmService extends ChangeNotifier {
  static const int _notificationId = 1001;
  static const String _channelId = 'tahajjud_alarm';
  static const String _channelName = 'Tahajjud alarm';
  static const String _channelDescription =
      'Tahajjud reminder notification with Adhan sound.';

  static const String actionStop = 'STOP_ALARM';
  static const String actionStopLabelEn = 'Stop';
  static const String actionStopLabelFr = 'Arrêter';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  DateTime? _lastScheduledAt;
  bool _permissionRequestedOnce = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      final tzName = tzInfo.identifier;
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (_) {
      // If timezone lookup fails, tz.local will be used.
    }

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
  }

  Future<bool?> requestPermission() async {
    await init();
    _permissionRequestedOnce = true;
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return androidImpl?.requestNotificationsPermission();
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

    // Don't spam permission prompts: only schedule if permission was already
    // requested at least once (via the "Autoriser" button or OS prompt).
    if (!_permissionRequestedOnce) return;

    final next = prayerTimeService.lastThirdTime;
    // Avoid rescheduling too often.
    if (_lastScheduledAt != null &&
        (_lastScheduledAt!.difference(next).inSeconds).abs() < 5) {
      return;
    }


    await scheduleAlarm(
      at: next,
      ringtoneKey: settings.ringtone,
      isEnglish: settings.language == 'en',
      settingsService: settingsService,
    );
  }

  Future<void> scheduleAlarm({
    required DateTime at,
    required String ringtoneKey,
    required bool isEnglish,
    required SettingsService settingsService,
    bool isTest = false,
  }) async {
    await init();

    // Check if today is an active day (1=Monday, 7=Sunday)
    final today = DateTime.now().weekday; // DateTime.weekday: 1=Monday, 7=Sunday
    final activeDays = settingsService.settings.activeDays;
    
    if (!activeDays.contains(today)) {
      debugPrint('⏭️ Alarm not scheduled: Today ($today) is not in active days $activeDays');
      return;
    }

    final scheduled = at.isAfter(DateTime.now())
        ? at
        : at.add(const Duration(days: 1));
    _lastScheduledAt = scheduled;

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      // For custom sound, you must add an MP3 to:
      // android/app/src/main/res/raw/<ringtoneKey>.mp3
      sound: RawResourceAndroidNotificationSound(ringtoneKey),
      actions: [
        AndroidNotificationAction(
          actionStop,
          isEnglish ? actionStopLabelEn : actionStopLabelFr,
          cancelNotification: true,
        ),
      ],
    );

    final details = NotificationDetails(android: androidDetails);

    final title = isEnglish ? 'Tahajjud' : 'Tahajjud';
    final body = isTest
        ? (isEnglish
            ? 'Test notification — tap Stop to silence.'
            : 'Notification test — appuyez sur Arrêter pour couper.')
        : (isEnglish
            ? 'Time to wake up for Tahajjud.'
            : 'Il est temps de se réveiller pour Tahajjud.');

    await _plugin.zonedSchedule(
      _notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduled, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: isTest ? null : DateTimeComponents.time,
    );
  }

  Future<void> showTestNotification({
    required String ringtoneKey,
    required bool isEnglish,
    required SettingsService settingsService,
  }) async {
    await init();
    
    // Explicitly request/check permission before test for better UX
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    // Show a "pseudo-immediate" notification for the test
    // Use 'show' instead of 'zonedSchedule' for the test to ensure it works regardless of time issues
    
    final androidDetails = AndroidNotificationDetails(
      'test_channel_high',
      'Alertes de test',
      channelDescription: 'Canal pour les tests de notification',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(ringtoneKey),
    );

    final details = NotificationDetails(android: androidDetails);
    
    final title = isEnglish ? 'Test Khayr' : 'Test Khayr';
    final body = isEnglish 
        ? 'Ceci est une notification de test.' 
        : 'Ceci est une notification de test.';

    // Use show directly for the test
    await _plugin.show(
      999, 
      title, 
      body, 
      details,
      payload: 'test',
    );
  }

  Future<void> cancelAlarm() async {
    await init();
    _lastScheduledAt = null;
    await _plugin.cancel(_notificationId);
  }
}

