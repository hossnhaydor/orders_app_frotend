import 'package:flutter/material.dart';

class PageIndexPorvider extends ChangeNotifier {
  int _currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  int get currentindex => _currentIndex;
  PageController get pageController => _pageController;
  void changePage(int index) {
    _pageController.jumpToPage(index);
    _currentIndex = index;
    notifyListeners();
  }
}
