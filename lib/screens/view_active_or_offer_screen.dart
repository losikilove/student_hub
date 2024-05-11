import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_tabbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/enums/enum_status_flag.dart';
import 'package:student_hub/models/proposal_model.dart';
import 'package:student_hub/screens/approve_project_screen.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewActiveOrOfferScreen extends StatefulWidget {
  final List<ProposalStudent> proposals;

  const ViewActiveOrOfferScreen({super.key, required this.proposals});

  @override
  State<ViewActiveOrOfferScreen> createState() =>
      _ViewActiveOrOfferScreenState();
}

class _ViewActiveOrOfferScreenState extends State<ViewActiveOrOfferScreen>
    with SingleTickerProviderStateMixin {
  late final List<TabView> _tabViews = [
    TabView(
        tab: Tab(text: AppLocalizations.of(context)!.activeProposals),
        widget: _activeProposalsPart()),
    TabView(
      tab:  Tab(text: AppLocalizations.of(context)!.offeredProposals),
      widget: _offeredProposalsPart(),
    ),
  ];
  late final TabController _tabController =
      TabController(vsync: this, length: _tabViews.length);

  late List<ProposalStudent> _offeredProposals;
  late List<ProposalStudent> _activeProposals;

  @override
  void initState() {
    super.initState();

    _activeProposals = widget.proposals
        .where((proposal) => proposal.statusFlag == EnumStatusFlag.active.value)
        .toList();
    _offeredProposals = widget.proposals
        .where((proposal) => proposal.statusFlag == EnumStatusFlag.offer.value)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: () {},
        isBack: true,
        title: AppLocalizations.of(context)!.activeOfferedProposals,
        currentContext: context,
        iconButton: null,
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

  // active proposal widget
  Widget _activeProposalsPart() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _activeProposals.length,
      itemBuilder: (context, index) {
        final proposal = _activeProposals[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              proposal.project.title,
              style: const TextStyle(
                  color: Color.fromARGB(255, 6, 194, 13), fontSize: 16),
            ),
            CustomText(
              text: "${AppLocalizations.of(context)!.submitedAt}: ${DateFormat('dd-MM-yyyy').format(
                DateTime.parse(proposal.createdAt.toString()),
              )}",
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            CustomText(text: AppLocalizations.of(context)!.studentAreLookingFor),
            CustomBulletedList(
              listItems: proposal.project.description.split("\n"),
            ),
            const CustomDivider(),
          ],
        );
      },
    );
  }

  // offered proposal widget
  Widget _offeredProposalsPart() {
    return StatefulBuilder(builder: (context, setState) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _offeredProposals.length,
        itemBuilder: (context, index) {
          final proposal = _offeredProposals[index];

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApproveProjectScreen(proposal: proposal),
              ),
            ).then((value) {
              if (proposal.statusFlag != EnumStatusFlag.offer.value) {
                setState(() {
                  _offeredProposals.remove(proposal);
                });
              }
            }),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proposal.project.title,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 6, 194, 13), fontSize: 16),
                  ),
                  CustomText(
                    text: "${AppLocalizations.of(context)!.submitedAt}: ${DateFormat('dd-MM-yyyy').format(
                      DateTime.parse(proposal.createdAt.toString()),
                    )}",
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  CustomText(text: AppLocalizations.of(context)!.studentAreLookingFor),
                  CustomBulletedList(
                    listItems: proposal.project.description.split("\n"),
                  ),
                  const CustomDivider(),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
