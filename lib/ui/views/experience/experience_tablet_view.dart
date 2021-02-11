import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/ScreenUtils.dart';
import 'package:portfolio/ui/views/experience/experience_view_model.dart';

class ExperienceTabletView extends StatelessWidget {
  final UIHelpers uiHelpers;
  final ExperienceViewModel model;

  const ExperienceTabletView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: PersonalDetails.experienceList.length,
        child: Container(
          width: uiHelpers.width,
          height: uiHelpers.height,
          child: Container(
            padding: const EdgeInsets.only(left: 10).copyWith(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Experience",
                  style: uiHelpers.headline.copyWith(fontSize: 45),
                ),
                uiHelpers.verticalSpaceMedium,
                TabBar(
                    labelStyle: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                    unselectedLabelStyle: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w300,fontSize:16),
                    unselectedLabelColor: textSecondaryColor,
                    labelColor: primaryColor,
                    isScrollable: true,
                    physics: BouncingScrollPhysics(),
                    tabs: [
                      for (int i = 0;
                          i < PersonalDetails.experienceList.length;
                          i++)
                        Tab(
                          child: Text(PersonalDetails.experienceList[i].title),
                        )
                    ]),
                Expanded(
                  child:
                      TabBarView(physics: BouncingScrollPhysics(), children: [
                    for (int i = 0;
                        i < PersonalDetails.experienceList.length;
                        i++)
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              uiHelpers.verticalSpaceLow,
                              RichText(
                                text: TextSpan(
                                    text:
                                        PersonalDetails.experienceList[i].title,
                                    style: uiHelpers.title
                                        .copyWith(color: textPrimaryColor),
                                    children: [
                                      TextSpan(
                                        text:
                                            "  @${PersonalDetails.experienceList[i].position}",
                                        style: uiHelpers.body
                                            .copyWith(color: primaryColor),
                                      )
                                    ]),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "${PersonalDetails.experienceList[i].timePeriod}",
                                style: uiHelpers.body
                                    .copyWith(color: textSecondaryColor),
                              ),
                              uiHelpers.verticalSpaceLow,
                              for (int j = 0;
                                  j <
                                      PersonalDetails
                                          .experienceList[i].description.length;
                                  j++)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(ExperienceIcon.arrowIcon, size: 20),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(PersonalDetails
                                            .experienceList[i].description[j]),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
