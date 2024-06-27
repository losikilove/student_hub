import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_tabbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/enums/enum_status_flag.dart';
import 'package:student_hub/models/enums/enum_type_flag.dart';
import 'package:student_hub/models/proposal_model.dart';
import 'package:student_hub/services/proposal_service.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class DashboardStudent extends StatefulWidget {
  const DashboardStudent({super.key});

  @override
  State<DashboardStudent> createState() => _DashboardStudentState();
}

class _DashboardStudentState extends State<DashboardStudent>
    with SingleTickerProviderStateMixin {
  late final List<TabView> _tabViews = [
    TabView(
      tab: Tab(text: AppLocalizations.of(context)!.allProjects),
      widget: _studentAllProjectContent(),
    ),
    TabView(
      tab: Tab(text: AppLocalizations.of(context)!.working),
      widget: _studentWorkingContent(),
    ),
    TabView(
      tab: Tab(text: AppLocalizations.of(context)!.archived),
      widget: _studentArchievedContent(),
    ),
  ];
  late final TabController _tabController =
      TabController(vsync: this, length: _tabViews.length);

  @override
  void initState() {
    super.initState();
  }

  List<ProposalStudent> _projects = [];

  Future<List<ProposalStudent>> inittializeProject() async {
    final response =
        await ProposalService.getAllProjectMyStudent(context: context);
    return ProposalStudent.fromResponse(response);
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
                                "${AppLocalizations.of(context)!.submitedAt}: ${DateFormat('dd-MM-yyyy').format(
                              DateTime.parse(project.createdAt.toString()),
                            )}",
                          ),
                          const SizedBox(
                            height: SpacingUtil.smallHeight,
                          ),
                          CustomText(text: AppLocalizations.of(context)!.studentAreLookingFor),
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
    List<ProposalStudent> waitingProjects = _projects
        .where((element) => element.statusFlag == EnumStatusFlag.waitting.value)
        .toList();
    List<ProposalStudent> activeProjects = _projects
        .where((element) =>
            element.statusFlag == EnumStatusFlag.active.value ||
            element.statusFlag == EnumStatusFlag.offer.value)
        .toList();

    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: SpacingUtil.mediumHeight,
        ),
        GestureDetector(
          // switch to see details of active or offered proposals
          onTap: () => NavigationUtil.toViewActiveOrOfferScreen(
              context,
              _projects
                  .where((element) =>
                      element.statusFlag == EnumStatusFlag.active.value ||
                      element.statusFlag == EnumStatusFlag.offer.value)
                  .toList()),
          child: Card(
              shape: Border.all(),
              child: Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: CustomText(
                        text:
                            "${AppLocalizations.of(context)!.activeOfferedProposals}(${activeProjects.length})",
                        isBold: true,
                      )))),
        ),
        const SizedBox(
          height: SpacingUtil.smallHeight,
        ),
        Card(
            shape: Border.all(),
            child: Container(
                width:  MediaQuery.of(context).size.width*0.9,
                height: MediaQuery.of(context).size.height*0.57,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            text:
                                "${AppLocalizations.of(context)!.submitProposal}(${waitingProjects.length})",
                            isBold: true,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.5-70,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ListView.builder(
                                itemCount: waitingProjects.length,
                                itemBuilder: (context, index) {
                                  final project = waitingProjects[index];
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
                                            "${AppLocalizations.of(context)!.submitedAt}: ${DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                              project.createdAt.toString()),
                                        )}",
                                      ),
                                      const SizedBox(
                                        height: SpacingUtil.smallHeight,
                                      ),
                                      CustomText(
                                          text: AppLocalizations.of(context)!.studentAreLookingFor),
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
          return  Center(
            child: Text(AppLocalizations.of(context)!.somethingWentWrong),
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
          return Center(
            child: Text(AppLocalizations.of(context)!.somethingWentWrong),
          );
        } else {
          _projects = snapshot.data!
              .where((element) =>
                  element.statusFlag == EnumStatusFlag.hired.value &&
                  element.project.typeFlag == EnumTypeFlag.working)
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
          return Center(
            child: Text(AppLocalizations.of(context)!.somethingWentWrong),
          );
        } else {
          _projects = snapshot.data!
              .where((element) =>
                  element.project.typeFlag == EnumTypeFlag.archive &&
                  element.statusFlag == EnumStatusFlag.hired.value)
              .toList();
          return _buildProjectWorkingList();
        }
      },
    );
  }
}
