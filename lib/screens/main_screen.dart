import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
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
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.list_outlined),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.message_outlined),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.notifications),
            label: 'Arlets',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.onBackground,
        onTap: _onItemTapped,
        unselectedItemColor: Theme.of(context).colorScheme.background,
      ),
    );
  }
}
