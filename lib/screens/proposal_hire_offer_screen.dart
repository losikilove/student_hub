import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/candidate_model.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProposalHireOfferScreen extends StatefulWidget {
  //TODO: get data of project

  const ProposalHireOfferScreen({super.key});

  @override
  State<ProposalHireOfferScreen> createState() =>
      _ProposalHireOfferScreenState();
}

class _ProposalHireOfferScreenState extends State<ProposalHireOfferScreen>
    with SingleTickerProviderStateMixin {
  late final List<_TabView> _tabViews = [
    _TabView(tab: const Tab(text: 'Proposal'), widget: _proposalContent()),
    _TabView(tab: const Tab(text: 'Detail'), widget: _detailContent()),
    _TabView(tab: const Tab(text: 'Message'), widget: _messageContent()),
    _TabView(tab: const Tab(text: 'Hired'), widget: _hiredContent())
  ];
  late TabController _tabController;
  final List<CandidateModel> _candidates = [
    CandidateModel(
      'Hung Le',
      '4th year student',
      'Fullstack Engineer',
      'Excellent',
      'I have gone through your project and it seems like a great project. I will commit for your project.',
      false,
    ),
    CandidateModel(
      'Quan Nguuyen',
      '3th year student',
      'Backend Engineer',
      'Excellent',
      'I have gone through your project and it seems like a great project. I will commit for your project.',
      false,
    ),
  ];
  List<CandidateModel> _hiredCandidates = [];

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
            CustomText(
              text: 'Title of project',
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // tabbar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const BoxDecoration(color: ColorUtil.darkPrimary),
                controller: _tabController,
                tabs: _tabViews.map((e) => e.tab).toList(),
                labelColor: Colors.white,
                indicatorColor: ColorUtil.darkPrimary,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // tabbar view
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
  // proposal content
  Widget _proposalContent() {
    return ListView.builder(
      itemCount: _candidates.length,
      itemBuilder: (context, index) {
        return StatefulBuilder(
          builder: (context, setState) {
            final candidate = _candidates[index];
            String hireText = candidate.isHired ? 'Sent hired offer' : 'Hire';

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
                        CustomButton(onPressed: _onCancelled, text: 'Cancel'),
                        CustomButton(
                          onPressed: _onSent,
                          text: 'Send',
                          buttonColor: ColorUtil.darkPrimary,
                        ),
                      ],
                    );
                  });

              // denies a hired offer for student
              if (showDialogHired == null || showDialogHired == false) {
                return;
              }

              // accepts a hired offer for student
              setState(() {
                candidate.changeHiredCandidate();
                hireText = candidate.isHired ? 'Sent hired offer' : 'Hire';
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
                    CustomText(text: candidate.profession),
                    CustomText(text: candidate.level),
                  ],
                ),
                const SizedBox(
                  height: SpacingUtil.smallHeight,
                ),
                CustomText(
                  text: candidate.description,
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
                      buttonColor: ColorUtil.darkPrimary,
                    ),
                    // hired button
                    CustomButton(
                      onPressed: onHired,
                      text: hireText,
                      buttonColor: candidate.isHired
                          ? ColorUtil.primary
                          : ColorUtil.darkPrimary,
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
  }

  // detail content
  Widget _detailContent() {
    return Center();
  }

  // message content
  Widget _messageContent() {
    return Center();
  }

  // hired content
  Widget _hiredContent() {
    return Center();
  }
}

class _TabView {
  final Tab tab;
  final Widget widget;

  const _TabView({required this.tab, required this.widget});
}
