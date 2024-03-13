import 'package:flutter/material.dart';
import 'package:student_hub/screens/content_body/main_screen/dashboard_body.dart';
import 'package:student_hub/screens/content_body/main_screen/message_body.dart';
import 'package:student_hub/screens/content_body/main_screen/notification_body.dart';
import 'package:student_hub/screens/content_body/main_screen/project_body.dart';

enum MainScreenIndex {
  project(number: 0),
  dashboard(number: 1),
  message(number: 2),
  notification(number: 3);

  final int number;

  const MainScreenIndex({required this.number});
}

class MainScreen extends StatefulWidget {
  final MainScreenIndex contentBody;

  const MainScreen({super.key, required this.contentBody});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  final name = 'Hai';
  late int _selectedIndex = widget.contentBody.number;
  static const List<Widget> _widgetOptions = <Widget>[
    ProjectBody(),
    DashboardBody(),
    MessageBody(),
    NotificationBody(),
  ];

  void onPressed() {}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Arlets',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 52, 145, 231),
        onTap: _onItemTapped,
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}
