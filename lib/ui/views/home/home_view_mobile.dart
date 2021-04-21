import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/widgets/icon_wrapper.dart';

import 'home_view_model.dart';

class HomeMobileView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final HomeViewModel model;

  const HomeMobileView({Key key, this.uiHelpers, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiHelpers.backgroundColor,
      body: Stack(
        children: [
          Container(
              width: uiHelpers.width,
              height: uiHelpers.height,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset("assets/images/sk_logo.png",
                        height: 40,
                        width: 40,
                        color: uiHelpers.textPrimaryColor),
                    IconWrrapper(
                      margin: const EdgeInsets.all(0),
                      color: uiHelpers.primaryColor,
                      padding: const EdgeInsets.all(8),
                      onTap: () => model.navigateToUrl(SocialLinks.githubLink),
                      child: Icon(
                        MenuIcons.contactIcon,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text(
                  "Portfolio",
                  style: uiHelpers.body,
                ),
                SizedBox(height: 8),
                Text(
                  "Hello,I'm",
                  style: uiHelpers.headline,
                ),
                Text(
                  "Shashi Kumar",
                  style: uiHelpers.headline,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 50.0,
                    child: PageView.builder(
                      itemCount: model.titles.length,
                      controller: model.pageController,
                      itemBuilder: (_, index) {
                        return model.titles[index];
                      },
                      scrollDirection: Axis.horizontal,
                    )),
                SizedBox(
                  height: 30,
                ),
                Row(children: [
                  IconWrrapper(
                    margin: const EdgeInsets.all(0),
                    color: uiHelpers.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    onTap: () => model.navigateToUrl(SocialLinks.githubLink),
                    child: Text(
                      "Contact",
                      style:
                          uiHelpers.buttonStyle.copyWith(color: Colors.white),
                    ),
                  ),
                  IconWrrapper(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    onTap: () => model.navigateToUrl(SocialLinks.githubLink),
                    child: Text(
                      "Download CV",
                      style: uiHelpers.buttonStyle,
                    ),
                  )
                ]),
              ], crossAxisAlignment: CrossAxisAlignment.start)),
        ],
      ),
    );
  }
}
