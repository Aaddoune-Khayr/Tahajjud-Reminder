import 'package:flutter/material.dart';
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
