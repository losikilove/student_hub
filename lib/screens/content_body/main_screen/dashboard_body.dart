import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_tabbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/utils/text_util.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBody();
}

class _DashboardBody extends State<DashboardBody>
    with SingleTickerProviderStateMixin {
  late final List<TabView> _tabViews = [
    TabView(
        tab: const Tab(text: 'All projects'), widget: _allProjectsContent()),
    TabView(tab: const Tab(text: 'Working'), widget: _workingContent()),
    TabView(tab: const Tab(text: 'Archived'), widget: _archievedContent())
  ];
  late TabController _tabController;
  final List<ProjectModel> _projects = [
    ProjectModel('Senior frontend developer (Fintech)', 'Created 3 days ago',
        ['Clear expectation about your project'], false, 0, 8, 2),
    ProjectModel('Senior frontend developer (Fintech)', 'Created 5 days ago',
        ['Clear expectation about your'], false, 0, 8, 2)
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
        void onOpenedActionMenu() {
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
                            child: Text(
                              'View proposel',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size(
                                  0,
                                  15,
                                )),
                          ),
                          TextButton(
                            onPressed: onPressed,
                            child: Text(
                              'View message',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size(0, 15)),
                          ),
                          TextButton(
                            onPressed: onPressed,
                            child: Text(
                              'View hired',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size(
                                  0,
                                  15,
                                )),
                          ),
                          CustomDivider(isFullWidth: true),
                          TextButton(
                            onPressed: onPressed,
                            child: Text(
                              'View job posting',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size(
                                  0,
                                  15,
                                )),
                          ),
                          TextButton(
                            onPressed: onPressed,
                            child: Text(
                              'Edit posting',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size(
                                  0,
                                  15,
                                )),
                          ),
                          TextButton(
                            onPressed: onPressed,
                            child: Text(
                              'Remove posting',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(30, 0, 250, 0),
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, //tap target
                                minimumSize: Size(
                                  0,
                                  15,
                                ) //size
                                ),
                          ),
                        ],
                      ),
                    ),
                    Builder(builder: (context) {
                      if (!_projects[index].isCompelte)
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
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 50, 0),
                                      tapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, //tap target
                                      minimumSize: Size(
                                        200,
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
