import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_tabbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/proposal_model.dart';
import 'package:student_hub/services/proposal_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

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

  List<ProposalStudent> _projects = [];

  Future<List<ProposalStudent>> inittializeProject() async {
    final response =
        await ProposalService.getAllProjectMyStudent(context: context);
    if (response.statusCode == StatusCode.ok.code) {
      debugPrint(response.body);
      return ProposalStudent.fromResponse(response);
    } else {
      throw Exception('Failed to load projects');
    }
  }

  @override
  void dispose() {
    // dispose the tab controller
    _tabController.dispose();
    super.dispose();
  }

  void onPressed() {}

  // switch to switch account screen
  void onSwitchedToSwitchAccountScreen() {
    NavigationUtil.toSwitchAccountScreen(context);
  }

  Widget _buildProjectWorkingList() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 400,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ListView.builder(
                    itemCount: _projects.length,
                    itemBuilder: (context, index) {
                      final project = _projects[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.project.title,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 6, 194, 13),
                                fontSize: 16),
                          ),
                          CustomText(
                            text:
                                "Submitted at: ${DateFormat('dd-MM-yyyy').format(
                              DateTime.parse(project.createdAt.toString()),
                            )}",
                          ),
                          const SizedBox(
                            height: SpacingUtil.smallHeight,
                          ),
                          const CustomText(text: "Student are looking for"),
                          CustomBulletedList(
                            listItems: project.project.description.split("\n"),
                          ),
                          const CustomDivider(),
                        ],
                      );
                    }),
              )
            ])),
      ],
    ));
  }

  Widget _buildProjectSubmitedList() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
            shape: Border.all(),
            child: Container(
                width: 400,
                height: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary),
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CustomText(
                      text:
                          "Active proposal(${_projects.where((element) => element.statusFlag == 1).length})",
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
                          CustomText(
                            text: "Submitted proposal(${_projects.length})",
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
                                        project.project.title,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 6, 194, 13),
                                            fontSize: 16),
                                      ),
                                      CustomText(
                                        text:
                                            "Submitted at: ${DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                              project.createdAt.toString()),
                                        )}",
                                      ),
                                      const SizedBox(
                                        height: SpacingUtil.smallHeight,
                                      ),
                                      const CustomText(
                                          text: "Student are looking for"),
                                      CustomBulletedList(
                                        listItems: project.project.description
                                            .split("\n"),
                                      ),
                                      const CustomDivider(),
                                    ],
                                  );
                                }),
                          )
                        ])))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onSwitchedToSwitchAccountScreen,
        currentContext: context,
      ),
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
    return FutureBuilder<List<ProposalStudent>>(
      future: inittializeProject(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading projects'),
          );
        } else {
          _projects = snapshot.data!;
          return _buildProjectSubmitedList();
        }
      },
    );
  }

  Widget _studentWorkingContent() {
    return FutureBuilder<List<ProposalStudent>>(
      future: inittializeProject(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading projects'),
          );
        } else {
          _projects = snapshot.data!
              .where((element) => element.statusFlag == 1)
              .toList();
          return _buildProjectWorkingList();
        }
      },
    );
  }

  Widget _studentArchievedContent() {
    return FutureBuilder<List<ProposalStudent>>(
      future: inittializeProject(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading projects'),
          );
        } else {
          _projects = snapshot.data!
              .where((element) => element.project.typeFlag == 1)
              .toList();
          return _buildProjectWorkingList();
        }
      },
    );
  }
}
