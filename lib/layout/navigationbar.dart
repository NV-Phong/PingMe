import 'package:flutter/material.dart';
import 'package:pingme/screens/beta/home_screen.dart';
import 'package:pingme/screens/beta/profile_screen.dart';
import 'package:pingme/screens/beta/settings_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline), // Icon cho Chat
            selectedIcon: Icon(Icons.chat_bubble), // Icon khi được chọn
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline), // Icon cho Profile
            selectedIcon: Icon(Icons.person), // Icon khi được chọn
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined), // Icon cho Settings
            selectedIcon: Icon(Icons.settings), // Icon khi được chọn
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
