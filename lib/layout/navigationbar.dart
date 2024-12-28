import 'package:flutter/material.dart';
import 'package:pingme/screens/blank_screen.dart';
import 'package:pingme/screens/env_screen.dart';
import 'package:pingme/screens/test_api_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  final List<Widget> pages = [
    const BlankScreen(),
    const EnviromentVariable(),
    const TestAPIScreen(),
    // const Center(child: Text('Messages Page')),
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
            icon: Icon(Icons.message),
            label: 'Blank Screen',
          ),
          NavigationDestination(
            icon: Icon(Icons.message),
            label: 'Blank Screen',
          ),
          NavigationDestination(
            icon: Icon(Icons.message),
            label: 'Blank Screen',
          ),
        ],
      ),
    );
  }
}
