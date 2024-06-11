import 'package:flutter/material.dart';

class BottomNavController {
  final int pageDefault;
  late final PageController _pageController;
  late int _selectedIndex;

  BottomNavController({required this.pageDefault}) {
    _pageController = PageController(initialPage: pageDefault);
    _selectedIndex = pageDefault;
  }

  void navigateTo(int index) {
    _pageController.jumpToPage(index);
    _selectedIndex = index;
  }

  int get currentIndex => _pageController.page?.round() ?? 0;

  PageController get controller => _pageController;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    navigateTo(index);
  }
}
