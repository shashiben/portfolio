import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
      backgroundColor: uiHelpers.backgroundColor,
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
            NeumorphicText(
              "Hello, this is",
              style: NeumorphicStyle(color:uiHelpers. primaryColor),
              textStyle: NeumorphicTextStyle(
                  fontSize: 20, fontWeight: FontWeight.w300, letterSpacing: 1),
            ),
            SizedBox(height: 10),
            FadeAnimation(
              delay: 1,
              yDistance: 10.0,
              xDistance: 0.0,
              child: NeumorphicText(
                PersonalDetails.userName,
                style: NeumorphicStyle(color: uiHelpers.textPrimaryColor),
                textStyle: NeumorphicTextStyle(
                    fontSize: 60, fontWeight: FontWeight.bold),
              ),
            ),
            FadeAnimation(
              delay: 2,
              yDistance: 20.0,
              xDistance: 0.0,
              child: NeumorphicText(
                PersonalDetails.shortIntro,
                style: NeumorphicStyle(color: uiHelpers.textSecondaryColor),
                textStyle: NeumorphicTextStyle(
                    fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            uiHelpers.verticalSpaceLow,
            FadeAnimation(
              delay: 2.5,
              yDistance: 30.0,
              xDistance: 0.0,
              child: MouseRegion(
                  onEnter: (event) => model.changeHoveredBoolean(true),
                  onExit: (event) => model.changeHoveredBoolean(false),
                  child: NeumorphicButton(
                    onPressed: () => model.getInTouch(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    style: NeumorphicStyle(
                        border: NeumorphicBorder(
                          isEnabled: true,
                          color: uiHelpers.surfaceColor,
                          width: 2,
                        ),
                        intensity: 8,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                        color: uiHelpers.backgroundColor,
                        lightSource: LightSource.topLeft,
                        depth: model.isHoveredOnGetInTouch ? -20 : 4,
                        surfaceIntensity: 0.5,
                        shape: model.isHoveredOnGetInTouch
                            ? NeumorphicShape.flat
                            : NeumorphicShape.flat),
                    child: NeumorphicText("Get In Touch",style: NeumorphicStyle(color: uiHelpers.textPrimaryColor),),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
