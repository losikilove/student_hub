import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_tabbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/project_company_model.dart';
import 'package:student_hub/screens/proposal_hire_offer_screen.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/utils/text_util.dart';

class DashboardCompany extends StatefulWidget {
  const DashboardCompany({super.key});

  @override
  State<DashboardCompany> createState() => _DashboardCompanyState();
}

class _DashboardCompanyState extends State<DashboardCompany>
    with SingleTickerProviderStateMixin {
  late final List<TabView> _tabViews = [
    TabView(
        tab: const Tab(text: 'All projects'),
        widget: _companyAllProjectContent()),
    TabView(tab: const Tab(text: 'Working'), widget: _companyWorkingContent()),
    TabView(
        tab: const Tab(text: 'Archived'), widget: _companyArchievedContent())
  ];
  late TabController _tabController =
      TabController(vsync: this, length: _tabViews.length);

  List<ProjectMyCompanyModel> _projects = [];

  Future<List<ProjectMyCompanyModel>> initializeProject() async {
    final response =
        await ProjectService.getAllProjectMyCompany(context: context);
    if (response.statusCode == StatusCode.ok.code) {
      debugPrint(response.body);
      return ProjectMyCompanyModel.fromResponse(response);
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Widget _buildProjectList() {
    return ListView.builder(
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        final project = _projects[index];

        // see detail of this project
        void onSeenDetail() {
          NavigationUtil.toProposalHireOfferScreen(
            context,
            ProposalHiredType.proposals,
            project,
          );
        }

        // handle actions of this project

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
                            text: "Time created: ${DateFormat('dd-MM-yyyy').format(
                              DateTime.parse(project.createdAt.toString()),
                            )}",
                          ),
                        ],
                      ),
                      // icon button seeing detail of this project
                      IconButton(
                        onPressed: () {
                          onOpenedActionMenu(project);
                        },
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
                  CustomBulletedList(
                    listItems: project.description.split('\n') as List<String>,
                  ),
                  // parameters of this project
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // number of proposals
                      Column(
                        children: [
                          CustomText(
                            text: project.countProposals.toString(),
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
                            text: project.countMessages.toString(),
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
                            text: project.countMessages
                                .toString(), // should be countHired instead of countMessages
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

  @override
  void dispose() {
    // dispose the tab controller
    _tabController.dispose();
    super.dispose();
  }

  // switch to switch account screen
  void onSwitchedToSwitchAccountScreen() {
    NavigationUtil.toSwitchAccountScreen(context);
  }

  void onPressed() {}
  void onEditProject(ProjectMyCompanyModel project) {
    NavigationUtil.toUpdateProjectScreen(context, project);
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
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Yours job',
                  ),
                  CustomButton(
                      onPressed: () {
                        NavigationUtil.toPostProjectStep1(context);
                      },
                      text: 'Post a job')
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

  Widget _companyAllProjectContent() {
    return FutureBuilder<List<ProjectMyCompanyModel>>(
      future: initializeProject(),
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
          if (_projects.isEmpty) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CustomText(text: 'Welcome, !'),
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
          return _buildProjectList();
        }
      },
    );
  }

  // company working content
  Widget _companyWorkingContent() {
    return FutureBuilder<List<ProjectMyCompanyModel>>(
      future: initializeProject(),
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
              .where((projectModel) => projectModel.typeFlag.value.isEven)
              .toList();
          if (_projects.isEmpty) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CustomText(text: 'Welcome, !'),
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
          return _buildProjectList();
        }
      },
    );
  }

  // companyArchievedContent
  Widget _companyArchievedContent() {
    return FutureBuilder<List<ProjectMyCompanyModel>>(
      future: initializeProject(),
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
              .where((projectModel) => projectModel.typeFlag.value.isOdd)
              .toList();
          if (_projects.isEmpty) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CustomText(text: 'Welcome!'),
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
          return _buildProjectList();
        }
      },
    );
  }

  void onOpenedActionMenu(ProjectMyCompanyModel project) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 120,
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
                      onPressed: () {
                        // closes the bottom sheet
                        Navigator.pop(context);
                        // goes to the screen
                        NavigationUtil.toProposalHireOfferScreen(
                          context,
                          ProposalHiredType.proposals,
                          project,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(30, 0, 200, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: const Size(0, 15),
                      ),
                      child: const CustomText(
                        text: 'View proposal',
                        size: TextUtil.smallTextSize,
                      ),
                    ),
                    TextButton(
                      onPressed: onPressed,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(30, 0, 200, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: const Size(0, 15),
                      ),
                      child: const CustomText(
                        text: 'View message',
                        size: TextUtil.smallTextSize,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // closes the bottom sheet
                        Navigator.pop(context);
                        // goes to the screen
                        NavigationUtil.toProposalHireOfferScreen(
                          context,
                          ProposalHiredType.hired,
                          project,
                        );
                      },
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(30, 0, 200, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(0, 15)),
                      child: const CustomText(
                        text: 'View hired',
                        size: TextUtil.smallTextSize,
                      ),
                    ),
                    const CustomDivider(isFullWidth: true),
                    TextButton(
                      onPressed: onPressed,
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(30, 0, 200, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(0, 15)),
                      child: const CustomText(
                        text: 'View job posting',
                        size: TextUtil.smallTextSize,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onEditProject(project);
                      },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap, //tap target
                          minimumSize: Size(
                            0,
                            15,
                          ) //size
                          ),
                      child: const CustomText(
                        text: 'Edit posting',
                        size: TextUtil.smallTextSize,
                      ),
                    ),
                    TextButton(
                      onPressed: onPressed,
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap, //tap target
                          minimumSize: Size(
                            0,
                            15,
                          ) //size
                          ),
                      child: const CustomText(
                        text: 'Remove posting',
                        size: TextUtil.smallTextSize,
                      ),
                    ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                if (project.typeFlag.value.isEven)
                  return Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDivider(
                            isFullWidth: true,
                          ),
                          TextButton(
                            onPressed: onPressed,
                            child: Text(
                              'Start working this project',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, //tap target
                                minimumSize: Size(
                                  0,
                                  15,
                                ) //size
                                ),
                          )
                        ]),
                  );
                return Container(
                  height: 0,
                );
              })
            ],
          ),
        );
      },
    );
  }
}
