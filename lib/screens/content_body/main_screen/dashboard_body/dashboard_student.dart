import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_tabbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProjectModel {
  final String _title;
  final String _timeCreating;
  final List<String> _wishes;
  bool _isCompelte;
  bool _like;
  int _numberProposals;
  int _numberMessages;
  int _numberHires;

  ProjectModel(
    this._title,
    this._timeCreating,
    this._wishes,
    this._isCompelte,
    this._like,
    this._numberProposals,
    this._numberMessages,
    this._numberHires,
  );
  set setLike(bool flag) {
    _like = flag;
  }

  String get title => _title;
  String get timeCreating => _timeCreating;
  List<String> get wishes => _wishes;
  bool get isCompelte => _isCompelte;
  bool get like => _like;
  int get numberProposals => _numberProposals;
  int get numberMessages => _numberMessages;
  int get numberHires => _numberHires;
}

class DashboardStudent extends StatefulWidget {
  const DashboardStudent({super.key});

  @override
  State<DashboardStudent> createState() => _DashboardStudentState();
}

class _DashboardStudentState extends State<DashboardStudent>
    with SingleTickerProviderStateMixin {
  late final List<TabView> _tabViews = [
    TabView(
        tab: const Tab(text: 'All projects'),
        widget: _studentAllProjectContent()),
    TabView(tab: const Tab(text: 'Working'), widget: _studentWorkingContent()),
    TabView(
        tab: const Tab(text: 'Archived'), widget: _studentArchievedContent()),
  ];
  late final TabController _tabController =
      TabController(vsync: this, length: _tabViews.length);
  final List<ProjectModel> _projects = [
    ProjectModel('Senior frontend developer (Fintech)', 'Created 3 days ago',
        ['Clear expectation about your project'], true, false, 0, 8, 2),
    ProjectModel('Senior frontend developer (Fintech)', 'Created 5 days ago',
        ['Clear expectation about your'], false, false, 0, 8, 2),
    ProjectModel('Senior frontend developer (Fintech)', 'Created 5 days ago',
        ['Clear expectation about your'], false, false, 0, 8, 2)
  ];
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
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

  Widget _studentAllProjectContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
            shape: Border.all(),
            child: Container(
                width: 400,
                height: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary),
                child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: CustomText(
                      text: "Active proposal(1)",
                      isBold: true,
                    )))),
        const SizedBox(
          height: SpacingUtil.mediumHeight,
        ),
        Card(
            shape: Border.all(),
            child: Container(
                width: 400,
                height: 450,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Submitted proposal(1)",
                            isBold: true,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            height: 395,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ListView.builder(
                                itemCount: _projects.length,
                                itemBuilder: (context, index) {
                                  final project = _projects[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        project.title,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 6, 194, 13),
                                            fontSize: 16),
                                      ),
                                      const CustomText(
                                          text: "Submited 3 days ago"),
                                      const SizedBox(
                                        height: SpacingUtil.smallHeight,
                                      ),
                                      const CustomText(
                                          text: "Student are looking for"),
                                      CustomBulletedList(
                                          listItems: project.wishes),
                                      const CustomDivider(),
                                    ],
                                  );
                                }),
                          )
                        ])))),
      ],
    );
  }

  Widget _studentWorkingContent() {
    List<ProjectModel> projectWorking =
        _projects.where((projectModel) => !projectModel.isCompelte).toList();
    if (_projects.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomText(text: 'Welcome, Hai!'),
          ),
          SizedBox(
            height: SpacingUtil.smallHeight,
          ),
          Center(
            child: CustomText(text: 'You have no jobs!'),
          ),
        ],
      );
    }
    return ListView.builder(
        itemCount: projectWorking.length,
        itemBuilder: (context, index) {
          final project = projectWorking[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 6, 194, 13), fontSize: 16),
              ),
              const CustomText(text: "Time: 6 months, 4 students needed"),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              const CustomText(text: "Student are looking for"),
              CustomBulletedList(listItems: project.wishes),
              const CustomDivider(),
            ],
          );
        });
  }

  Widget _studentArchievedContent() {
    List<ProjectModel> projectArchieved =
        _projects.where((projectModel) => projectModel.isCompelte).toList();
    if (_projects.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomText(text: 'Welcome, Hai!'),
          ),
          SizedBox(
            height: SpacingUtil.smallHeight,
          ),
          Center(
            child: CustomText(text: 'You have no jobs!'),
          ),
        ],
      );
    }
    return ListView.builder(
        itemCount: projectArchieved.length,
        itemBuilder: (context, index) {
          final project = projectArchieved[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 6, 194, 13), fontSize: 16),
              ),
              const CustomText(text: "Time: 6 months, 4 students needed"),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              const CustomText(text: "Student are looking for"),
              CustomBulletedList(listItems: project.wishes),
              const CustomDivider(),
            ],
          );
        });
  }
}
