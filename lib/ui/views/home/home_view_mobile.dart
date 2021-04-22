import 'package:carousel_slider/carousel_slider.dart';
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
                  height: 25,
                ),
                Container(
                    height: 175.0,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                          viewportFraction: 1),
                      itemCount: PersonalDetails.skillDisplayList.length,
                      itemBuilder: (_, index, realIndex) {
                        return Container(
                          width: uiHelpers.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                PersonalDetails
                                    .skillDisplayList[index].iconData,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                PersonalDetails.skillDisplayList[index].title,
                                style: uiHelpers.title.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: SystemProperties.fontName),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color:
                                  PersonalDetails.skillDisplayList[index].color,
                              borderRadius: BorderRadius.circular(12)),
                        );
                      },
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
