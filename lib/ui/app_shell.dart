import 'package:flutter/material.dart';
import 'feed/feed_screen.dart';
import 'photos/photo_capture_screen.dart';
import 'profile/profile_screen.dart';
import 'widgets/app_page_app_bar.dart';
import 'widgets/bottom_tab_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

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
      bottomNavigationBar: BottomTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
