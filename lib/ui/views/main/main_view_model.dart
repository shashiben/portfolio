import 'package:flutter/material.dart';
import 'package:portfolio/ui/views/home/home_view.dart';
import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel {
  int index = 0;

  final Map<String, Widget> views = {
    "Home": HomeView(),
    "About": Container(color: Colors.white),
    "Projects": Container(color: Colors.red),
    "Blog": Container(color: Colors.pink),
    "Contact": Container(color: Colors.teal)
  };

  changeIndex(
      int newIndex, TabController controller, PageController pageController,
      [bool isTabThere]) async {
    index = newIndex;
    if (!(isTabThere != null)) {
      controller.index = newIndex;
      controller.animateTo(newIndex);
    }

    await pageController.animateToPage(newIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOutCubic);
    notifyListeners();
  }

  changePageState(int index, TabController controller) {
    controller.animateTo(index);
    notifyListeners();
  }

  init(BuildContext context) {}
}
