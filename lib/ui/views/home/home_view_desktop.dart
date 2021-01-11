import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUtils.dart';

import 'home_view_model.dart';

class HomeDesktopView extends StatelessWidget {
  final UIHelpers uiHelpers;
  final HomeViewModel model;

  const HomeDesktopView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(right: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 60),
            uiHelpers.verticalSpaceLow,
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TypewriterAnimatedTextKit(
                  text: ["Hello,This is Shashi Kumar.I\'m a "],
                  speed: Duration(milliseconds: 100),
                  textStyle: uiHelpers.title,
                  totalRepeatCount: 1,
                  onFinished: () => model.changeIntroToCompleted(),
                ),
                !model.isIntroCompleted
                    ? SizedBox()
                    : ScaleAnimatedTextKit(
                        duration: Duration(seconds: 2),
                        text: [
                          "Flutter Developer",
                          "Mean Stack Developer",
                          "FReMP Stack",
                          "Java Developer",
                          "Full Stack Developer",
                          "React Developer",
                          "Python Developer"
                        ],
                        textStyle: uiHelpers.title,
                        textAlign: TextAlign.center),
              ],
            ),
            uiHelpers.verticalSpaceMedium,
            MaterialButton(
              hoverElevation: 100,
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Explore My Projects",
                    style: uiHelpers.title.copyWith(color: textPrimaryColor),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios, color: textPrimaryColor)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
