import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

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
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Project(),
    Dashboard(),
    Message(),
    Notification(),
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
      body: InitialBody(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
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
        selectedItemColor: Color.fromARGB(255, 52, 145, 231),
        onTap: _onItemTapped,
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  void onPressed() {}
  List<bool> _selections = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Row(
            children: [
              Text(
                'Yours job',
              ),
              const SizedBox(
                width: 180,
              ),
              CustomButton(onPressed: onPressed, text: 'Post a job')
            ],
          ),
        ),
        Center(
          child: ToggleButtons(
          constraints: const BoxConstraints(
            minHeight: 32.0,
            minWidth: 100,
          ),
          children: [
            Text('All Projects', style: TextStyle(color: Colors.black),),
            Text('Working', style: TextStyle(color: Colors.black)),
            Text('Archive', style: TextStyle(color: Colors.black)),
          ],
          fillColor: const Color.fromARGB(255, 102, 179, 241),
          isSelected: _selections,
          onPressed: (index) {
            setState(() {
              for (int buttonIndex = 0; buttonIndex < _selections.length; buttonIndex++) {
                if (buttonIndex == index) {
                  _selections[buttonIndex] = true;
                } else {
                  _selections[buttonIndex] = false;
                }
              }
            });
            
          },
        ),
        ),
        
        SizedBox(
          height: SpacingUtil.largeHeight,
        ),
        Center(
          child: CustomText(text: 'Welcome, Hai!'),
        ),
        SizedBox(
          height: SpacingUtil.smallHeight,
        ),
        Center(
          child: CustomText(text: 'You have no jobs!'),
        )
      ],
    );
  }
}

class Project extends StatefulWidget {
  const Project({super.key});

  @override
  State<Project> createState() => _Project();
}

class _Project extends State<Project> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // when switch to main screen with chosen project, show the dialog welcome
      showDialogWelcome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center();
  }

  Future showDialogWelcome() => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Welcome',
              style: TextStyle(
                color: ColorUtil.darkPrimary,
              ),
            ),
          ),
          content: const CustomText(
            text:
                'Welcome to StudentHub, a marketplace to connect Student to Real-world projects',
            isCenter: true,
          ),
          actions: [
            CustomButton(
              onPressed: () => NavigationUtil.turnBack(context),
              text: 'Next',
              size: CustomButtonSize.large,
            ),
          ],
        );
      });
}

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _Message();
}

class _Message extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _Notification();
}

class _Notification extends State<Notification> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
