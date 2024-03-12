import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_divider.dart';
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
        
        const SizedBox(
          height: SpacingUtil.largeHeight,
        ),
        const Center(
          child: CustomText(text: 'Welcome, Hai!'),
        ),
        const SizedBox(
          height: SpacingUtil.smallHeight,
        ),
        const Center(
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
  String searchItem ="Search for project";
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // when switch to main screen with chosen project, show the dialog welcome
      showDialogWelcome();
    });
  }

  final List<String> suggestion = ["reactjs","flutter","education app"];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child:ElevatedButton.icon(
                    onPressed: (){
                      _showBottomSheet(context);
                    },
                    icon: const Icon(Icons.search),
                    label: CustomText(text: searchItem,),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      alignment: Alignment.centerLeft
                    ),
                  )
                ),
                const SizedBox(
                  width: 32,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding:const EdgeInsets.all(0.2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2DAAD4), // Màu nền của nút
                    ),
                    child:IconButton(
                      onPressed: (){},
                        icon:const Icon(Icons.favorite,
                        color: Colors.white,
                      )
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const CustomDivider(),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Created 3 days ago"),
                      Text("Senior Frontend developer(Fintech)",
                      style: TextStyle(
                        color:Color.fromARGB(255, 3, 230, 11),
                        fontSize: 16
                        ),
                      ),
                      CustomText(text: "Time: 1-3 months, 6 students needed"),
                      SizedBox(
                        height: SpacingUtil.mediumHeight,
                      ),
                      CustomText(text: "Student are looking for"),
                      CustomBulletedList(
                        listItems: ["Clear expectation about your project or deliverables"]
                      ),
                      CustomText(text: "Less than 5"),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: (){},
                    icon:const Icon(Icons.favorite_border_outlined,
                    color: Color.fromARGB(255, 0, 78, 212),
                    size: 30,
                  )
                ),
              ],
            ),
            const CustomDivider(),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Created 5 days ago"),
                      Text("Senior Frontend developer(Fintech)",
                      style: TextStyle(
                        color:Color.fromARGB(255, 3, 230, 11),
                        fontSize: 16
                        ),
                      ),
                      CustomText(text: "Time: 6 months, 4 students needed"),
                      SizedBox(
                        height: SpacingUtil.mediumHeight,
                      ),
                      CustomText(text: "Student are looking for"),
                      CustomBulletedList(
                        listItems: ["Clear expectation about your project or deliverables"]
                      ),
                      CustomText(text: "Less than 5"),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: (){},
                    icon:const Icon(Icons.favorite_border_outlined,
                    color: Color.fromARGB(255, 0, 78, 212),
                    size: 30,
                  )
                ),
              ],
            ),
            const CustomDivider(),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Created 5 days ago"),
                      Text("Senior Frontend developer(Fintech)",
                      style: TextStyle(
                        color:Color.fromARGB(255, 3, 230, 11),
                        fontSize: 16
                        ),
                      ),
                      CustomText(text: "Time: 6 months, 4 students needed"),
                      SizedBox(
                        height: SpacingUtil.mediumHeight,
                      ),
                      CustomText(text: "Student are looking for"),
                      CustomBulletedList(
                        listItems: ["Clear expectation about your project or deliverables"]
                      ),
                      CustomText(text: "Less than 5"),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: (){},
                    icon:const Icon(Icons.favorite_border_outlined,
                    color: Color.fromARGB(255, 0, 78, 212),
                    size: 30,
                  )
                ),
              ],
            ),
          ],
        ),
    ); 
  } 

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Đặt chiều cao ban đầu tại đây
            child: SingleChildScrollView(
              child: Container(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 10.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search for project',
                    ),
                  ),
                  ListTile(
                    title: const CustomText(text: 'ReactJS'),
                    onTap: () {
                      setState(() {
                        searchItem ="React JS";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const CustomText(text: 'Education App'),
                    onTap: () {
                    setState(() {
                      searchItem ="Education App";
                    });
                    Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const CustomText(text: "Flutter",),
                      onTap: () {
                      setState(() {
                        searchItem ="Flutter";
                      });
                      Navigator.pop(context);
                    },
                  ),  
                ],
              ),
            ),
          ),
        );
      },
    );
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
    }
  );
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
