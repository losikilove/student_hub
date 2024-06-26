import 'package:flutter/material.dart';

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
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: tabController,
        tabs: tabs,
        labelColor: Theme.of(context).colorScheme.secondary,
        indicatorColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
