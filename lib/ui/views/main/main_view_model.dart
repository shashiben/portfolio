import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/ui/views/about%20me/about_view.dart';
import 'package:portfolio/ui/views/contact%20me/contact_view.dart';
import 'package:portfolio/ui/views/experience/experience_view.dart';
import 'package:portfolio/ui/views/home/home_view.dart';
import 'package:portfolio/ui/views/projects/project_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel {
  int index = 0;
  bool isIntroCompleted = false;
  PageController pageController = PageController();
  bool isIndex3 = false;

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
      isIndex3 = (index == 3);
      notifyListeners();
    }
  }

  List<CollapsibleItem> get generateItems {
    return [
      CollapsibleItem(
          text: 'Home',
          icon: MenuIcons.homeIcon,
          onPressed: () {
            isIndex3 = false;
            child = views[0];
            notifyListeners();
          },
          isSelected: true),
      CollapsibleItem(
        text: 'About',
        icon: MenuIcons.aboutIcon,
        onPressed: () {
          isIndex3 = false;

          child = views[1];
          notifyListeners();
        },
      ),
      CollapsibleItem(
        text: 'Projects',
        icon: MenuIcons.projectIcon,
        onPressed: () {
          isIndex3 = false;

          child = views[2];
          notifyListeners();
        },
      ),
      CollapsibleItem(
        text: 'Experience',
        icon: MenuIcons.experienceIcon,
        onPressed: () {
          isIndex3 = true;
          child = views[3];
          notifyListeners();
        },
      ),
      CollapsibleItem(
        text: 'Contact',
        icon: MenuIcons.contactIcon,
        onPressed: () {
          isIndex3 = false;
          child = views[4];
          notifyListeners();
        },
      ),
    ];
  }

  isMobile(context) {
    return getDeviceType(MediaQuery.of(context).size) ==
        DeviceScreenType.mobile;
  }

  init() {
    collapsibleItem = generateItems;
    child = views.first;
    notifyListeners();
  }
}
