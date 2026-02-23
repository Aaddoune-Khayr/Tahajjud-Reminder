import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khayr__tahajjud_reminder/theme.dart';
import 'package:khayr__tahajjud_reminder/nav.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';
import 'package:khayr__tahajjud_reminder/services/prayer_time_service.dart';
import 'package:khayr__tahajjud_reminder/services/alarm_service.dart';

import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsService>(
          create: (_) => SettingsService()..loadSettings(),
        ),
        ChangeNotifierProxyProvider<SettingsService, PrayerTimeService>(
          create: (_) => PrayerTimeService(),
          update: (_, settingsService, prayerService) {
            final service = prayerService ?? PrayerTimeService();
            service.updateSettings(
              autoLocation: settingsService.settings.autoLocation,
            );
            return service;
          },
        ),
        ChangeNotifierProxyProvider2<SettingsService, PrayerTimeService, AlarmService>(
          create: (_) => AlarmService(),
          update: (_, settingsService, prayerService, alarmService) {
            final service = alarmService ?? AlarmService();
            service.syncFromProviders(
              settingsService: settingsService,
              prayerTimeService: prayerService,
            );
            return service;
          },
        ),
      ],
      child: Consumer<SettingsService>(
        builder: (context, settingsService, child) {
          return MaterialApp.router(
            title: 'Khayr - Tahajjud Reminder',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settingsService.settings.darkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
