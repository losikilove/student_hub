import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_tabbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/candidate_model.dart';
import 'package:student_hub/models/enums/enum_status_flag.dart';
import 'package:student_hub/models/project_company_model.dart';
import 'package:student_hub/services/proposal_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';

enum ProposalHiredType {
  proposals(value: 0, name: 'Proposals'),
  details(value: 1, name: 'Details'),
  message(value: 2, name: 'Message'),
  hired(value: 3, name: 'Hired');

  final int value;
  final String name;

  const ProposalHiredType({required this.value, required this.name});
}

class ProposalHireOfferScreen extends StatefulWidget {
  final ProposalHiredType type;
  final ProjectCompanyModel currentProject;

  const ProposalHireOfferScreen(
      {super.key, required this.type, required this.currentProject});

  @override
  State<ProposalHireOfferScreen> createState() =>
      _ProposalHireOfferScreenState();
}

class _ProposalHireOfferScreenState extends State<ProposalHireOfferScreen>
    with SingleTickerProviderStateMixin {
  late final List<TabView> tabViews = [
    TabView(tab: const Tab(text: 'Proposal'), widget: _proposalContent()),
    TabView(tab: const Tab(text: 'Detail'), widget: _detailContent()),
    TabView(tab: const Tab(text: 'Message'), widget: _messageContent()),
    TabView(tab: const Tab(text: 'Hired'), widget: _hiredContent())
  ];
  late TabController _tabController;
  List<CandidateModel> _hiredCandidates = [];

  @override
  void initState() {
    super.initState();

    // initial the tab controller
    _tabController = TabController(
      vsync: this,
      length: tabViews.length,
      initialIndex: widget.type.value,
    );
  }

  @override
  void dispose() {
    // dispose the tab controller
    _tabController.dispose();
    super.dispose();
  }

  void onPressed() {}

  // initialize proposal
  Future<List<CandidateModel>> initializeProposal() async {
    final response = await ProposalService.getProposalByProject(
      context: context,
      projectId: (widget.currentProject as ProjectMyCompanyModel).projectId,
    );

    return CandidateModel.fromResponse(
      ApiUtil.getResult(response)['items'] as List<dynamic>,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
        isBack: true,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title of project
            const Text(
              "Title of job",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // tabbar
            CustomTabBar(
              tabController: _tabController,
              tabs: tabViews.map((e) => e.tab).toList(),
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // tabbar view
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: tabViews.map((e) => e.widget).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widgets contain content of tab
  // proposal content
  Widget _proposalContent() {
    return CustomFutureBuilder(
      future: initializeProposal(),
      widgetWithError: (snapshot) => CustomText(
        text: snapshot.error.toString(),
        textColor: Colors.red,
      ),
      widgetWithData: (snapshot) {
        // just get status flag is waiting or offer
        List<CandidateModel> candidates = snapshot.data!
            .where((element) => element.statusFlag != EnumStatusFlag.hired)
            .toList();

        return ListView.builder(
          itemCount: candidates.length,
          itemBuilder: (context, index) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                final candidate = candidates[index];
                String hireText = candidate.statusFlag == EnumStatusFlag.offer
                    ? 'Sent hired offer'
                    : 'Hire';

                void onMessaged() {}

                void onHired() async {
                  // show and get data of dialog which accepts or denies the hired offer
                  final showDialogHired = await showDialog(
                      context: context,
                      builder: (context) {
                        // cancel the hired offer
                        void _onCancelled() {
                          Navigator.of(context).pop(false);
                        }

                        // accept the hired offer
                        void _onSent() {
                          Navigator.of(context).pop(true);
                        }

                        return AlertDialog(
                          title: const Center(
                            child: Text(
                              'Hired offer',
                            ),
                          ),
                          content: const CustomText(
                            text:
                                'Do you want to send hired offer to this guy to do this project?',
                          ),
                          actions: [
                            CustomButton(
                                onPressed: _onCancelled, text: 'Cancel'),
                            CustomButton(
                              onPressed: _onSent,
                              text: 'Send',
                              buttonColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        );
                      });

                  // denies a hired offer for student
                  if (showDialogHired == null || showDialogHired == false) {
                    return;
                  }

                  // accepts a hired offer for student
                  setModalState(() {
                    candidate.changeHiredCandidate(EnumStatusFlag.offer);
                    hireText = candidate.statusFlag == EnumStatusFlag.offer
                        ? 'Sent hired offer'
                        : 'Hire';
                  });
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // icon of candidate
                        const Icon(
                          Icons.person_outline,
                          size: 40.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // fullname of candidate
                            CustomText(text: candidate.fullname),
                            // year of study of candidate
                            CustomText(text: candidate.yearOfStudy),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: candidate.techStack),
                        CustomText(text: candidate.level),
                      ],
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    CustomText(
                      text: candidate.coverLetter,
                      size: 14.0,
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // message button
                        CustomButton(
                          onPressed: onMessaged,
                          text: 'Message',
                        ),
                        // hired button
                        CustomButton(
                          onPressed: onHired,
                          text: hireText,
                          buttonColor: Theme.of(context).colorScheme.secondary,
                          isDisabled:
                              candidate.statusFlag == EnumStatusFlag.offer,
                        ),
                      ],
                    ),
                    const CustomDivider(),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _projectRequirement(
      IconData icon, String title, String detailRequirement) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 35,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: title),
              CustomBulletedList(
                listItems: [detailRequirement],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // detail content
  Widget _detailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Student are looking for',
        ),
        CustomBulletedList(
          listItems: widget.currentProject.description.split('\n'),
        ),
        const CustomDivider(),
        // scope of project
        _projectRequirement(
          Icons.alarm,
          'Project scope',
          widget.currentProject.projectScopeFlag.name,
        ),
        const SizedBox(
          height: SpacingUtil.smallHeight,
        ),
        // Required students
        _projectRequirement(
          Icons.people_outline,
          'Required students',
          widget.currentProject.numberofStudent.toString(),
        ),
        SizedBox(
          height: SpacingUtil.largeHeight,
        ),
        Container(
          alignment: Alignment.topRight,
          child: CustomButton(onPressed: () {}, text: "Post job"),
        )
      ],
    );
  }

  // message content
  Widget _messageContent() {
    return Center();
  }

  // hired content
  Widget _hiredContent() {
    return CustomFutureBuilder(
      future: initializeProposal(),
      widgetWithError: (snapshot) => CustomText(
        text: snapshot.error.toString(),
        textColor: Colors.red,
      ),
      widgetWithData: (snapshot) {
        // just get status flag is waiting or offer
        List<CandidateModel> candidates = snapshot.data!
            .where((element) => element.statusFlag == EnumStatusFlag.hired)
            .toList();

        return ListView.builder(
          itemCount: candidates.length,
          itemBuilder: (context, index) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                final candidate = candidates[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // icon of candidate
                        const Icon(
                          Icons.person_outline,
                          size: 40.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // fullname of candidate
                            CustomText(text: candidate.fullname),
                            // year of study of candidate
                            CustomText(text: candidate.yearOfStudy),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: candidate.techStack),
                        CustomText(text: candidate.level),
                      ],
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    CustomText(
                      text: candidate.coverLetter,
                      size: 14.0,
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    const CustomDivider(),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
