import 'package:flutter/material.dart';
import 'feed/feed_screen.dart';
import 'photos/photo_capture_screen.dart';
import 'profile/profile_screen.dart';
import 'widgets/app_page_app_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _highlightColor = Color(0xFFE4DDD4);
  static const _navigationBarColor = Color(0xFFCBC2B5);
  int _currentIndex = 0;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Accueil',
    ),
    NavigationDestination(
      icon: Icon(Icons.photo_camera_outlined),
      selectedIcon: Icon(Icons.photo_camera),
      label: 'Prendre une photo',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];

  static const _titles = [
    'Accueil',
    'Prendre une photo',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const FeedScreen(),
      const PhotoCaptureScreen(),
      const ProfileScreen(embedded: true),
    ];

    return Scaffold(
      appBar: AppPageAppBar(title: _titles[_currentIndex]),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: _navigationBarColor,
        indicatorColor: _highlightColor,
        selectedIndex: _currentIndex,
        destinations: _destinations,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
