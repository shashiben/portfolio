import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import '../../../app/icons.dart';
import '../../../core/services/url_launcher_service.dart';
import '../about%20me/about_view.dart';
import '../contact%20me/contact_view.dart';
import '../experience/experience_view.dart';
import '../home/home_view.dart';
import '../projects/project_view.dart';

class MainViewModel extends BaseViewModel {
  final UrlLauncherService _urlLauncherService = UrlLauncherService();
  int index = 0;
  bool isIntroCompleted = false;
  PageController pageController = PageController();
  bool isIndex3 = false;

  List<CollapsibleItem> collapsibleItem = [];
  final List<String> menuItems = [
    'Home',
    'About',
    'Projects',
    'Experience',
    'Contact'
  ];

  final List<Widget> views = <Widget>[
    HomeView(),
    AboutView(),
    const ProjectView(),
    ExperienceView(),
    ContactView(),
  ];

  late Widget child;
  void changeIntroToCompleted() {
    isIntroCompleted = true;
    notifyListeners();
  }

  Future<void> changeMenuForMobile(
      AnimationController? controller,
      AnimationController slideController,
      AnimationController? menuTextController) async {
    switch (slideController.status) {
      case AnimationStatus.completed:
        controller!.reverse();
        slideController.reverse();
        break;
      case AnimationStatus.dismissed:
        controller!.forward();
        slideController.forward();
        try {
          await menuTextController!.forward();
          await menuTextController.reverse();
        } on TickerCanceled {
          // the animation got canceled, probably because it was disposed of
        }
        break;

      default:
    }
  }

  void changeIndex(int newIndex,
      {bool isMobile = false,
      controller,
      slideController,
      menuTextController}) {
    if (newIndex != index) {
      index = newIndex;
      if (isMobile) {
        changeMenuForMobile(controller, slideController, menuTextController);
      }
      isIndex3 = index == 3;
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

  bool isMobile(BuildContext context) {
    return getDeviceType(MediaQuery.of(context).size) ==
        DeviceScreenType.mobile;
  }

  Future<void> openUrl(String url) async {
    await _urlLauncherService.launchUrl(url);
  }

  void init() {
    collapsibleItem = generateItems;
    child = views.first;
    notifyListeners();
  }
}
