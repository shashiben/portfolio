import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/services/url_launcher_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final UrlLauncherService _urlLauncherService = UrlLauncherService();
  PageController pageController = PageController();

  List<Widget> titles = [
    RichText(
        text: TextSpan(
            text: "Innovate Android Developer\nFlutter and Java",
            children: [
          TextSpan(text: "Android Developer\nFlutter"),
          TextSpan(text: "and"),
          TextSpan(text: "Java")
        ])),
    RichText(
        text: TextSpan(
            text: "Innovate Android Developer\nFlutter and Java",
            children: [
          TextSpan(text: "Android Developer\nFlutter"),
          TextSpan(text: "and"),
          TextSpan(text: "Java")
        ])),
    RichText(
        text: TextSpan(
            text: "Innovate Android Developer\nFlutter and Java",
            children: [
          TextSpan(text: "Android Developer\nFlutter"),
          TextSpan(text: "and"),
          TextSpan(text: "Java")
        ])),
  ];
  bool isIntroCompleted = false;
  bool isHoveredOnGetInTouch = false;
  bool isShortIntroCompleted = false;
  Map<String, String> skills = {
    "Mobile Developer": "assets/images/android.png",
    "Web Developer": "assets/images/web.png",
    "Designer": "assets/images/design.png",
    "AI Enthusiast": "assets/images/ml.png"
  };
  changeShortIntroToCompleted() {
    isShortIntroCompleted = true;
    notifyListeners();
  }

  changeHoveredBoolean(bool value) {
    isHoveredOnGetInTouch = value;
    notifyListeners();
  }

  changeIntroToCompleted() {
    isIntroCompleted = true;
    notifyListeners();
  }

  getInTouch() async {
    await _urlLauncherService.launchUrl(SocialLinks.linkedinUrl);
  }

  ding() {
    print("yo");
    pageController.animateToPage(
        ((pageController.page + 1) % titles.length).toInt(),
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic);
  }

  init() async {
    await Future.delayed(Duration(seconds: 1));

    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      pageController.animateToPage(
        ((pageController.page + 1) % titles.length).toInt(),
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  navigateToUrl(String url) async {
    await _urlLauncherService.launchUrl(url);
  }
}
