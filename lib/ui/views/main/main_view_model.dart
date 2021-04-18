import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/ui/views/about%20me/about_view.dart';
import 'package:portfolio/ui/views/contact%20me/contact_view.dart';
import 'package:portfolio/ui/views/experience/experience_view.dart';
import 'package:portfolio/ui/views/home/home_view.dart';
import 'package:portfolio/ui/views/projects/project_view.dart';
import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel {
  int index = 0;
  bool isIntroCompleted = false;
  PageController pageController = PageController();

  List<CollapsibleItem> collapsibleItem = [];
  final List<String> menuItems = [
    "Home",
    "About",
    "Projects",
    "Experience",
    "Contact"
  ];

  final views = [
    HomeView(),
    AboutView(),
    ProjectView(),
    ExperienceView(),
    ContactView(),
  ];

  Widget child;
  changeIntroToCompleted() {
    isIntroCompleted = true;
    notifyListeners();
  }

  changeMenuForMobile(
      AnimationController controller, AnimationController slideController) {
    switch (slideController.status) {
      case AnimationStatus.completed:
        controller.reverse();
        slideController.reverse();
        break;
      case AnimationStatus.dismissed:
        controller.forward();
        slideController.forward();
        break;

      default:
    }
  }

  changeIndex(int newIndex,
      {bool isMobile = false, controller, slideController}) {
    if (newIndex != index) {
      index = newIndex;
      if (isMobile) {
        changeMenuForMobile(controller, slideController);
      }
      notifyListeners();
    }
  }

  List<CollapsibleItem> get generateItems {
    return [
      CollapsibleItem(
          text: 'Home',
          icon: MenuIcons.homeIcon,
          onPressed: () {
            child = views[0];
            notifyListeners();
          },
          isSelected: true),
      CollapsibleItem(
        text: 'About',
        icon: MenuIcons.aboutIcon,
        onPressed: () {
          child = views[1];
          notifyListeners();
        },
      ),
      CollapsibleItem(
        text: 'Projects',
        icon: MenuIcons.projectIcon,
        onPressed: () {
          child = views[2];
          notifyListeners();
        },
      ),
      CollapsibleItem(
        text: 'Experience',
        icon: MenuIcons.experienceIcon,
        onPressed: () {
          child = views[3];
          notifyListeners();
        },
      ),
      CollapsibleItem(
        text: 'Contact',
        icon: MenuIcons.contactIcon,
        onPressed: () {
          child = views[4];
          notifyListeners();
        },
      )
    ];
  }

  init() {
    collapsibleItem = generateItems;
    child = views.first;
    notifyListeners();
  }
}
