import 'package:flutter/material.dart';

class PageNavigationHelper {
  final PageController pageController;
  final Function() onNextPage;
  final Function() onPreviousPage;

  PageNavigationHelper({
    required this.pageController,
    required this.onNextPage,
    required this.onPreviousPage,
  });

  void navigateToNext() {
    onNextPage();
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void navigateToPrevious() {
    onPreviousPage();
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
