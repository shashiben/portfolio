import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';

import 'home_view_model.dart';

class HomeTabletView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final HomeViewModel model;

  const HomeTabletView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(right: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello, this is",
              style: uiHelpers.buttonStyle.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1),
            ),
            SizedBox(height: 10),
            TypewriterAnimatedTextKit(
              text: ["${PersonalDetails.userName}."],
              speed: Duration(milliseconds: 100),
              textStyle: uiHelpers.title
                  .copyWith(fontSize: 60, color: Color(0xFFc6D6F6)),
              totalRepeatCount: 1,
              onFinished: () => model.changeIntroToCompleted(),
              repeatForever: false,
            ),
            Text(
              "I love build things for the web or mobile.",
              style: uiHelpers.headline
                  .copyWith(color: Color(0xFFc6D6F6), fontSize: 50),
            ),
            uiHelpers.verticalSpaceLow,
            Text(
              "",
              style: uiHelpers.body,
            ),
            uiHelpers.verticalSpaceMedium,
            MaterialButton(
              hoverElevation: 100,
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Get In touch",
                    style: uiHelpers.title.copyWith(
                        letterSpacing: 1,
                        color: primaryColor,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios, color: primaryColor, size: 25)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
