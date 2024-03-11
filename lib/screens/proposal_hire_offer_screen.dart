import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
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
            TabBar(
              controller: _tabController,
              tabs: _tabViews.map((e) => e.tab).toList(),
              dividerColor: ColorUtil.primary,
              labelColor: ColorUtil.darkPrimary,
              indicatorColor: ColorUtil.darkPrimary,
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
    return Center();
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
