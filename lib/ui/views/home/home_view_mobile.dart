import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';

import 'home_view_model.dart';

class HomeMobileView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final HomeViewModel model;

  const HomeMobileView({Key key, this.uiHelpers, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            uiHelpers.verticalSpaceMedium,
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
                  .copyWith(fontSize: 24, color: Color(0xFFc6D6F6)),
              totalRepeatCount: 1,
              onFinished: () => model.changeIntroToCompleted(),
              repeatForever: false,
            ),
            model.isIntroCompleted
                ? TypewriterAnimatedTextKit(
                    text: ["${PersonalDetails.shortIntro}"],
                    speed: Duration(milliseconds: 20),
                    textStyle: uiHelpers.title.copyWith(
                        fontSize: 18,
                        color: Color(0xFFc6D6F6),
                        fontWeight: FontWeight.w300),
                    totalRepeatCount: 1,
                    onFinished: () => model.changeShortIntroToCompleted(),
                    repeatForever: false,
                  )
                : SizedBox(),
            uiHelpers.verticalSpaceLow,
            AnimatedOpacity(
              duration: Duration(milliseconds: 700),
              opacity: model.isShortIntroCompleted ? 1.0 : 0.0,
              child: MaterialButton(
                hoverElevation: 100,
                elevation: 10,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () => model.getInTouch(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Get In touch",
                      style: uiHelpers.title.copyWith(
                          fontSize: 15,
                          letterSpacing: 1,
                          color: primaryColor,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios, color: primaryColor, size: 20)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
