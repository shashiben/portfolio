import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/widgets/fadeAnimation.dart';

import 'home_view_model.dart';

class HomeDesktopView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final HomeViewModel model;

  const HomeDesktopView({Key key, this.uiHelpers, this.model})
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
            FadeAnimation(
              delay: 1,
              yDistance: 10.0,
              xDistance: 0.0,
              child: Text(
                "${PersonalDetails.userName}.",
                style: uiHelpers.title
                    .copyWith(fontSize: 60, color: Color(0xFFc6D6F6)),
              ),
            ),
            FadeAnimation(
              delay: 2,
              yDistance: 20.0,
              xDistance: 0.0,
              child: Text(
                "I love build things for the web or mobile.",
                style: uiHelpers.headline
                    .copyWith(color: Color(0xFFc6D6F6), fontSize: 50),
              ),
            ),
            uiHelpers.verticalSpaceLow,
            FadeAnimation(
              delay: 2.5,
              yDistance: 30.0,
              xDistance: 0.0,
              child: MaterialButton(
                hoverElevation: 100,
                elevation: 10,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                          letterSpacing: 1,
                          color: primaryColor,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios, color: primaryColor, size: 25)
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
