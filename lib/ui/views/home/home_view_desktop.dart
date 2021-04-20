import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';

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
          padding: const EdgeInsets.all(60),
          child: Neumorphic(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            style: NeumorphicStyle(
              depth: NeumorphicTheme.embossDepth(context),
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/sk_logo.png",
                          width: 50,
                          height: 50,
                          color: uiHelpers.textPrimaryColor,
                        ),
                        Text(
                          "Shashi Kumar",
                          style: uiHelpers.title,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Resume",
                                style: uiHelpers.title,
                              ),
                            )),
                        TextButton(
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Contact",
                                style: uiHelpers.title,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: uiHelpers.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: model.skills.keys
                          .map((e) => Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                width: uiHelpers.width * 0.28,
                                child: Neumorphic(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Neumorphic(
                                          style: NeumorphicStyle(
                                            depth: NeumorphicTheme.embossDepth(
                                                context),
                                            boxShape:
                                                NeumorphicBoxShape.circle(),
                                          ),
                                          child: Image.asset(
                                            model.skills[e],
                                            width: 40,
                                            height: 40,
                                          )),
                                      SizedBox(width: 10),
                                      Text(
                                        e,
                                        style: uiHelpers.headline,
                                      )
                                    ],
                                  ),
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.concave,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(12)),
                                      depth: 8,
                                      intensity: 0.6,
                                      lightSource: LightSource.topLeft,
                                      color: uiHelpers.surfaceColor),
                                ),
                              ))
                          .toList(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            PersonalDetails.intro,
                            style: uiHelpers.body
                                .copyWith(height: 2, color: textPrimaryColor),
                          ),
                          width: uiHelpers.width * 0.3,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        NeumorphicButton(
                          onPressed: () {},
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
                              depth: 4,
                              surfaceIntensity: 0.5,
                              shape: NeumorphicShape.flat),
                          child: Row(
                            children: [
                              Icon(ContactIcons.githubIcon),
                              Text("Github")
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
