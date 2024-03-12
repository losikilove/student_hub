import 'package:flutter/material.dart';
import 'package:student_hub/utils/color_util.dart';

class TabView {
  final Tab tab;
  final Widget widget;

  const TabView({required this.tab, required this.widget});
}

// this widget is used with TabBarView widget
class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final List<Tab> tabs;

  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const BoxDecoration(color: ColorUtil.darkPrimary),
        controller: tabController,
        tabs: tabs,
        labelColor: Colors.white,
        indicatorColor: ColorUtil.darkPrimary,
      ),
    );
  }
}
