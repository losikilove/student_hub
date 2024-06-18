import 'package:flutter/material.dart';
import 'package:student_hub/screens/content_body/main_screen/dashboard_body.dart';
import 'package:student_hub/screens/content_body/main_screen/message_body.dart';
import 'package:student_hub/screens/content_body/main_screen/notification_body.dart';
import 'package:student_hub/screens/content_body/main_screen/project_body.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
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
  late int _selectedIndex = widget.contentBody.number;
  static const List<Widget> _widgetOptions = <Widget>[
    ProjectBody(),
    DashboardBody(),
    MessageBody(),
    NotificationBody(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SalomonBottomBar(
        margin: const EdgeInsets.all(15),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.list_outlined,size: 24,),
            title: const Text('Project',style: TextStyle(fontSize: 24),),
            selectedColor: Theme.of(context).colorScheme.secondary,
            unselectedColor: Theme.of(context).colorScheme.onPrimary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.dashboard_outlined,size: 24,),
            title: const Text('Dashboard',style: TextStyle(fontSize: 24)),
            selectedColor: Theme.of(context).colorScheme.secondary,
            unselectedColor: Theme.of(context).colorScheme.onPrimary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.message_outlined,size: 24,),
            title: const Text('Message',style: TextStyle(fontSize: 24)),
            selectedColor: Theme.of(context).colorScheme.secondary,
            unselectedColor: Theme.of(context).colorScheme.onPrimary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.notifications,size:24),
            title: const Text('Alerts',style: TextStyle(fontSize: 26)),
            selectedColor: Theme.of(context).colorScheme.secondary,
            unselectedColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
      )
    );
  }
}
