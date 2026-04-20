import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:khayr__tahajjud_reminder/services/alarm_service.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';
import 'package:khayr__tahajjud_reminder/components/floating_nav_bar.dart';
import 'package:khayr__tahajjud_reminder/screens/home_screen.dart';
import 'package:khayr__tahajjud_reminder/screens/duaa_screen.dart';
import 'package:khayr__tahajjud_reminder/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;
  late final PageController _pageController;

  final List<Widget> _screens = const [
    SettingsScreen(),
    HomeScreen(),
    DuaaScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionsAndShowPopup();
    });
  }

  Future<void> _checkPermissionsAndShowPopup() async {
    bool needsPermissions = false;

    if (await Permission.notification.isDenied || await Permission.notification.isPermanentlyDenied) {
      needsPermissions = true;
    }
    if (Platform.isAndroid) {
      final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
      if (!exactAlarmStatus.isGranted) {
        needsPermissions = true;
      }
    }

    if (needsPermissions && mounted) {
      final isEnglish = context.read<SettingsService>().settings.language == 'en';
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(isEnglish ? 'Permissions Needed' : 'Autorisations requises'),
          content: Text(isEnglish
              ? 'To wake you up exactly on time, Khayr needs permission to:\n\n1. Send notifications\n2. Set exact alarms\n\nPlease tap Allow to proceed.'
              : 'Pour que l\'alarme fonctionne correctement, Khayr a besoin des autorisations suivantes :\n\n1. Notifications\n2. Alarmes exactes\n\nMerci de les accepter.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await context.read<AlarmService>().requestPermission();
              },
              child: Text(isEnglish ? 'Allow' : 'Autoriser'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            // Disabling user scroll if we only want nav bar control. 
            // Enable it if swipe navigation is desired.
            physics: const ClampingScrollPhysics(), 
            onPageChanged: _onPageChanged,
            children: _screens,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            // Ensure FloatingNavBar sits above PageView
            child: FloatingNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }
}
