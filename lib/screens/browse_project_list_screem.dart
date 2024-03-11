import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

enum BrowseProjectListIndex {
  project(number: 0),
  dashboard(number: 1),
  message(number: 2),
  notification(number: 3);

  final int number;

  const BrowseProjectListIndex({required this.number});
}

class BrowseProjectList extends StatefulWidget {
  final BrowseProjectListIndex contentBody;

  const BrowseProjectList({super.key, required this.contentBody});

  @override
  State<BrowseProjectList> createState() => _BrowseProjectList();
}

class _BrowseProjectList extends State<BrowseProjectList> {
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
        selectedItemColor: Color.fromARGB(255, 52, 165, 231),
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

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class Project extends StatefulWidget {
  const Project({super.key});

  @override
  State<Project> createState() => _Project();
}

class _Project extends State<Project> {
 
  final List<String> suggestion = ["reactjs","flutter","education app"];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchAnchor(
                    builder: (BuildContext context, SearchController controller)
                    {
                      return SearchBar(
                        autoFocus: true,
                        controller: controller,
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                          onTap: () {
                          controller.openView();
                        },
                        onChanged: (_) {
                          controller.openView();
                        },
                        leading: const Icon(Icons.search),
                      );
                    }
                  ,suggestionsBuilder:(context, controller) {
                    return List<ListTile>.generate(3, (index) {
                        final String item = suggestion[index];
                      return ListTile(
                        title: CustomText(text: item),
                        onTap: (){
                          setState(() {
                            controller.closeView(item);
                           } 
                          );
                        }
                      ); 
                     }
                    );
                   },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding:const EdgeInsets.all(1.0),
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
