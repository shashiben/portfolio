import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/views/experience/experience_view_model.dart';
import 'package:portfolio/ui/widgets/experience_chip_widget.dart';
import 'package:portfolio/ui/widgets/fadeAnimation.dart';

class ExperienceDesktopView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final ExperienceViewModel model;

  const ExperienceDesktopView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiHelpers.backgroundColor,
      body: Container(
        width: uiHelpers.width,
        height: uiHelpers.height,
        child: Container(
          padding: const EdgeInsets.only(left: 10).copyWith(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Experience",
                style: uiHelpers.headline,
              ),
              Container(
                child: Divider(
                  color: dividerColor,
                  thickness: 1.5,
                ),
                width: uiHelpers.width * 0.06,
              ),
              uiHelpers.verticalSpaceLow,
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40)
                            .copyWith(right: 80),
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: PersonalDetails.experienceList.length,
                          itemBuilder: (context, index) {
                            return FadeAnimation(
                              delay: index * 0.2 + 1,
                              xDistance: 0,
                              yDistance: (20 + index * 5).toDouble(),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: uiHelpers.width * 0.4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                    text: PersonalDetails
                                                        .experienceList[index]
                                                        .title,
                                                    style: uiHelpers.headline,
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "  @${PersonalDetails.experienceList[index].position} ",
                                                        style: uiHelpers.body
                                                            .copyWith(
                                                                color:
                                                                    primaryColor),
                                                      )
                                                    ]),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    ExperienceIcon.timeIcon,
                                                    size: 15,
                                                    color: textSecondaryColor,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    PersonalDetails
                                                        .experienceList[index]
                                                        .timePeriod,
                                                    style: uiHelpers.body.copyWith(
                                                        color:
                                                            textSecondaryColor),
                                                  ),
                                                ],
                                              ),
                                              uiHelpers.verticalSpaceLow,
                                              Text(
                                                "Accomplishments",
                                                style: uiHelpers.title,
                                              ),
                                              for (int j = 0;
                                                  j <
                                                      PersonalDetails
                                                          .experienceList[index]
                                                          .description
                                                          .length;
                                                  j++)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                          ExperienceIcon
                                                              .arrowIcon,
                                                          size: 20),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        child: Text(
                                                            PersonalDetails
                                                                .experienceList[
                                                                    index]
                                                                .description[j]),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Tools Used:",
                                                style: uiHelpers.title,
                                              ),
                                              Container(
                                                child: Divider(
                                                  color: dividerColor,
                                                  thickness: 1.5,
                                                ),
                                                width: 75,
                                              ),
                                              Wrap(
                                                children: [
                                                  for (int k = 0;
                                                      k <
                                                          PersonalDetails
                                                              .experienceList[
                                                                  index]
                                                              .tools
                                                              .length;
                                                      k++)
                                                    ExperienceChipWidget(
                                                      title: PersonalDetails
                                                          .experienceList[index]
                                                          .tools[k],
                                                    )
                                                ],
                                              )
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      uiHelpers.verticalSpaceMedium,
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
