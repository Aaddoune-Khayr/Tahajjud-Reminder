import 'package:flutter/material.dart';
import 'package:khayr__tahajjud_reminder/components/floating_nav_bar.dart';
import 'package:khayr__tahajjud_reminder/screens/home_screen.dart';
import 'package:khayr__tahajjud_reminder/screens/duaa_screen.dart';
import 'package:khayr__tahajjud_reminder/screens/settings_screen.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';
import 'package:khayr__tahajjud_reminder/nav.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  final List<Widget> _screens = const [
    SettingsScreen(),
    HomeScreen(),
    DuaaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Trigger simple onboarding the first time the app is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsService>().settings;
      if (!settings.onboardingCompleted) {
        context.push(AppRoutes.onboarding);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0.05, 0.02),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(_currentIndex),
              child: _screens[_currentIndex],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
