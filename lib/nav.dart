import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khayr__tahajjud_reminder/screens/main_screen.dart';
import 'package:khayr__tahajjud_reminder/screens/onboarding_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => const MaterialPage(
          child: OnboardingScreen(),
        ),
      ),
    ],
  );
}

class AppRoutes {
  static const String home = '/';
  static const String onboarding = '/onboarding';
}
