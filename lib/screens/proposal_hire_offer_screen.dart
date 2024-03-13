import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_tabbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/candidate_model.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
class ProposalHireOfferScreen extends StatefulWidget {
  //TODO: get data of project

  const ProposalHireOfferScreen({super.key});

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
    _tabController = TabController(vsync: this, length: tabViews.length);
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
            const Text("Title of job",
              style: TextStyle(
                color:Colors.green, 
                fontSize:17,
                fontWeight: FontWeight.bold
              ),
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
                      buttonColor: ColorUtil.primary,
                    ),
                    // hired button
                    CustomButton(
                      onPressed: onHired,
                      text: hireText,
                      buttonColor: ColorUtil.darkPrimary,
                      isDisabled: candidate.isHired,
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
        const CustomBulletedList(
          listItems: [
           'Clear expectation about your project or deliverables',
           'The skills required for your project',
           'Detail about your project'
          ],
        ),
        const CustomDivider(),
            // scope of project
        _projectRequirement(Icons.alarm, 'Project scope', '3 to 6 months'),
        const SizedBox(
          height: SpacingUtil.smallHeight,
        ),
            // Required students
        _projectRequirement(
          Icons.people_outline, 'Required students', '6 students'),
        SizedBox(
          height: SpacingUtil.largeHeight,
        ),
        Container(
          alignment:Alignment.topRight ,
          child: CustomButton(
            onPressed: (){}, 
            text: "Post job"
          ),
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
    return Center();
  }
}
