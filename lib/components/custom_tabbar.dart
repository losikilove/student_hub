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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator:
            BoxDecoration(color: Theme.of(context).colorScheme.secondary),
        controller: tabController,
        tabs: tabs,
        labelColor: Colors.white,
        indicatorColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
