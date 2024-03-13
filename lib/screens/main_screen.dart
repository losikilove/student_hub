import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_tabbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/utils/text_util.dart';

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

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> with SingleTickerProviderStateMixin {
  late final List<TabView> _tabViews = [
    TabView(
        tab: const Tab(text: 'All projects'), widget: _allProjectsContent()),
    TabView(tab: const Tab(text: 'Working'), widget: _workingContent()),
    TabView(tab: const Tab(text: 'Archived'), widget: _archievedContent())
  ];
  late TabController _tabController;
  final List<ProjectModel> _projects = [
    ProjectModel('Senior frontend developer (Fintech)', 'Created 3 days ago',
        ['Clear expectation about your project'],false ,0, 8, 2),
    ProjectModel('Senior frontend developer (Fintech)', 'Created 5 days ago',
        ['Clear expectation about your'], false,0, 8, 2)
  ];

  @override
  void initState() {
    super.initState();

    // initial the tab controller
    _tabController = TabController(vsync: this, length: _tabViews.length);
  }

  @override
  void dispose() {
    // dispose the tab controller
    _tabController.dispose();
    super.dispose();
  }

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Yours job',
                  ),
                  CustomButton(onPressed: onPressed, text: 'Post a job')
                ],
              ),
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            CustomTabBar(
              tabController: _tabController,
              tabs: _tabViews.map((e) => e.tab).toList(),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabViews.map((e) => e.widget).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widgets contain content of tab
  // all projects content
  Widget _allProjectsContent() {
    if (_projects.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: CustomText(text: 'Welcome, Hai!'),
          ),
          const SizedBox(
            height: SpacingUtil.smallHeight,
          ),
          const Center(
            child: CustomText(text: 'You have no jobs!'),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        final project = _projects[index];

        // see detail of this project
        void onSeenDetail() {}

        // handle actions of this project
        void onOpenedActionMenu(){
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
            ),            
            context: context,
            builder: (BuildContext context) { 
              return ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 145,
                  maxHeight: double.maxFinite,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: onPressed,
                            child: Text('View proposel', style: TextStyle(color: Colors.black),),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size(0, 15, )
                            ),                        
                          ),
                          TextButton(
                            onPressed: onPressed,
                            child: Text('View message', style: TextStyle(color: Colors.black),),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size(0, 15)
                            ),
                          ),
                          TextButton(
                            onPressed: onPressed,
                            child: Text('View hired', style: TextStyle(color: Colors.black),),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size(0, 15,)
                            ),
                          ),
                          CustomDivider(isFullWidth: true),
                            TextButton(
                            onPressed: onPressed,
                            child: Text('View job posting', style: TextStyle(color: Colors.black),),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size(0, 15,)
                            ),
                          ),
                            TextButton(
                            onPressed: onPressed,
                            child: Text('Edit posting', style: TextStyle(color: Colors.black),),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size(0, 15,)
                            ),
                          ),
                            TextButton(
                            onPressed: onPressed,
                            child: Text('Reomve posting', style: TextStyle(color: Colors.black),),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,//tap target
                              minimumSize: Size(0, 15,)//size
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Builder(
                      builder: (context){
                        if(!_projects[index].isCompelte)
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomDivider(isFullWidth: true,),              
                                TextButton(
                                  onPressed: onPressed,
                                  child: Text('Start working this project', style: TextStyle(color: Colors.black),),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,//tap target
                                    minimumSize: Size(200, 15,)//size
                                  ),
                                )
                                
                              ]),
                          );
                        return Container(
                          height: 0,
                        );  
                      }
                    )
                  ],
                ),
              );
            },
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onSeenDetail,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // title of this project
                          CustomText(
                            text: project.title,
                            isBold: true,
                          ),
                          // time-creating of this project
                          CustomText(
                            text: project.timeCreating,
                            isItalic: true,
                          )
                        ],
                      ),
                      // icon button seeing detail of this project
                      IconButton(
                        onPressed: onOpenedActionMenu,
                        icon: const Icon(
                          Icons.playlist_add_circle_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  // wishes of this project
                  const CustomText(text: 'Student are looking for'),
                  CustomBulletedList(listItems: project.wishes),
                  // parameters of this project
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // number of proposals
                      Column(
                        children: [
                          CustomText(
                            text: project.numberProposals.toString(),
                            size: TextUtil.smallTextSize,
                          ),
                          const CustomText(
                            text: 'Proposals',
                            size: TextUtil.smallTextSize,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: SpacingUtil.largeHeight,
                      ),
                      // number of messages
                      Column(
                        children: [
                          CustomText(
                            text: project.numberMessages.toString(),
                            size: TextUtil.smallTextSize,
                          ),
                          const CustomText(
                            text: 'Messages',
                            size: TextUtil.smallTextSize,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: SpacingUtil.largeHeight,
                      ),
                      // number of hires
                      Column(
                        children: [
                          CustomText(
                            text: project.numberHires.toString(),
                            size: TextUtil.smallTextSize,
                          ),
                          const CustomText(
                            text: 'Hired',
                            size: TextUtil.smallTextSize,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const CustomDivider(
              isFullWidth: true,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
          ],
        );
      },
    );
  }

  // working content
  Widget _workingContent() {
    return const Center();
  }

  // archievedContent
  Widget _archievedContent() {
    return const Center();
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
  String searchItem ="Search for project";
  void onPressed() {}
  final List<String> suggestion = ["reactjs", "flutter", "education app"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
      ),
      body: InitialBody(
        child: SingleChildScrollView(
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
        ),
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
      });
}

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _Message();
}

class _Message extends State<Message> {
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: InitialBody(child: Center()),
    );
  }
}

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _Notification();
}

class _Notification extends State<Notification> {
  void onPressed() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: InitialBody(child: Center()),
    );
  }
}
