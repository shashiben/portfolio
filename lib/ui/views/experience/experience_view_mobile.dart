import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/views/experience/experience_view_model.dart';

class ExperienceMobileView extends StatelessWidget {
  final ScreenUiHelper? uiHelpers;
  final ExperienceViewModel? model;

  const ExperienceMobileView({Key? key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiHelpers!.backgroundColor,
      body: DefaultTabController(
        length: PersonalDetails.experienceList.length,
        child: Container(
          width: uiHelpers!.width,
          height: uiHelpers!.height,
          child: Container(
            padding: const EdgeInsets.only(left: 10).copyWith(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Experience",
                  style: uiHelpers!.headline,
                ),
                uiHelpers!.verticalSpaceLow,
                TabBar(
                    labelStyle: TextStyle(
                        color: uiHelpers!.primaryColor,
                        fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(
                        color: uiHelpers!.primaryColor,
                        fontWeight: FontWeight.w300),
                    unselectedLabelColor: uiHelpers!.textSecondaryColor,
                    labelColor: uiHelpers!.primaryColor,
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
                              uiHelpers!.verticalSpaceLow,
                              RichText(
                                text: TextSpan(
                                    text:
                                        PersonalDetails.experienceList[i].title,
                                    style: uiHelpers!.title!.copyWith(
                                        color: uiHelpers!.textPrimaryColor),
                                    children: [
                                      TextSpan(
                                        text:
                                            "  @${PersonalDetails.experienceList[i].position}",
                                        style: uiHelpers!.body!.copyWith(
                                            color: uiHelpers!.primaryColor),
                                      )
                                    ]),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "${PersonalDetails.experienceList[i].timePeriod}",
                                style: uiHelpers!.body!.copyWith(
                                    color: uiHelpers!.textSecondaryColor),
                              ),
                              uiHelpers!.verticalSpaceLow,
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(ExperienceIcon.arrowIcon,
                                            size: 20),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            PersonalDetails.experienceList[i]
                                                .description[index],
                                            style: uiHelpers!.body,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                itemCount:
                                    PersonalDetails.experienceList.length,
                              ),
                              uiHelpers!.verticalSpaceLow,
                              Text(
                                "Tools Used",
                                style: uiHelpers!.title,
                              ),
                              Container(
                                width: uiHelpers!.width! * 0.16,
                                child: Divider(
                                  color: uiHelpers!.dividerColor,
                                  thickness: 2.5,
                                ),
                              ),
                              uiHelpers!.verticalSpaceLow,
                              ListView.builder(
                                primary: false,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          ExperienceIcon.arrowIcon,
                                          color: uiHelpers!.textPrimaryColor,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          PersonalDetails
                                              .experienceList[i].tools[index],
                                          style: uiHelpers!.body,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: PersonalDetails
                                    .experienceList[i].tools.length,
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
