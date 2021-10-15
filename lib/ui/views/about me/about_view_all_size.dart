import 'package:flutter/material.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/core/utils/bootstrap/bootstrap_util.dart';
import 'package:portfolio/ui/views/about%20me/about_view_model.dart';
import 'package:portfolio/ui/widgets/divider_widget.dart';
import 'package:portfolio/ui/widgets/eductaion_timeline_widget.dart';
import 'package:portfolio/ui/widgets/featured_skill_widget.dart';
import 'package:portfolio/ui/widgets/skill_widget.dart';
import 'package:portfolio/ui/widgets/timeline_widget.dart';

class AboutViewResponsive extends StatelessWidget {
  final ScreenUiHelper? uiHelpers;
  final AboutViewModel? model;

  const AboutViewResponsive({Key? key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: uiHelpers!.backgroundColor,
        body: SingleChildScrollView(
          child: BootstrapContainer(
            padding: const EdgeInsets.only(top: 20.0),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Wow, a whole page about my journey!",
                  style: uiHelpers!.headline,
                ),
              ),
              SizedBox(height: 80),
              BootstrapRow(
                children: [
                  BootstrapCol(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Me,talking about myself",
                          style: uiHelpers!.title!.copyWith(fontSize: 24),
                        ),
                        Container(
                          width: 80,
                          child: DividerWidget(
                            width: 80,
                            dividerColor: uiHelpers!.primaryColor,
                          ),
                        ),
                        uiHelpers!.verticalSpaceLow,
                        Text(PersonalDetails.intro,
                            style: uiHelpers!.body!
                                .copyWith(color: uiHelpers!.textSecondaryColor)),
                        uiHelpers!.verticalSpaceMedium,
                        Text(
                          "Technical Skills",
                          style: uiHelpers!.title!.copyWith(fontSize: 24),
                        ),
                        Container(
                          width: 70,
                          child: DividerWidget(
                            width: 70,
                            dividerColor: uiHelpers!.primaryColor,
                          ),
                        ),
                        uiHelpers!.verticalSpaceLow,
                        SkillWidget(),
                        uiHelpers!.verticalSpaceMedium,
                        Text(
                          "Featured Skills",
                          style: uiHelpers!.title!.copyWith(fontSize: 24),
                        ),
                        Container(
                          width: 75,
                          child: DividerWidget(
                            width: 75,
                            dividerColor: uiHelpers!.primaryColor,
                          ),
                        ),
                        uiHelpers!.verticalSpaceLow,
                        FeaturedSkillWidget(),
                      ],
                    ),
                    sizes: "col-12 col-md-6 col-sm-12",
                  ),
                  BootstrapCol(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Education",
                          style: uiHelpers!.title!.copyWith(fontSize: 24),
                        ),
                        Container(
                          width: 70,
                          child: DividerWidget(
                            width: 70,
                            dividerColor: uiHelpers!.primaryColor,
                          ),
                        ),
                        SizedBox(height: 15),
                        Timeline(
                            indicatorSize: 16,
                            indicatorColor: uiHelpers!.primaryColor,
                            lineColor: uiHelpers!.textPrimaryColor,
                            shrinkWrap: true,
                            itemGap: 25,
                            lineGap: 0,
                            children: [
                              EducationDetailsTimelineWidget(
                                  name: EducationDetails.universityName,
                                  stream: EducationDetails.universityStream,
                                  year: EducationDetails.universityTimeline,
                                  percentage:
                                      EducationDetails.universityPercentage),
                              EducationDetailsTimelineWidget(
                                  name: EducationDetails.collegeName,
                                  stream: EducationDetails.collegeStream,
                                  year: EducationDetails.collegeTimeline,
                                  percentage:
                                      EducationDetails.collegePercentage),
                              EducationDetailsTimelineWidget(
                                  name: EducationDetails.schoolName,
                                  stream: EducationDetails.schoolStream,
                                  year: EducationDetails.schoolTimeline,
                                  percentage:
                                      EducationDetails.schoolPercentage),
                            ])
                      ],
                    ),
                    sizes: "col-12 col-md-6 col-sm-12",
                  )
                ],
                height: uiHelpers!.height,
              )
            ],
            fluid: true,
          ),
        ));
  }
}
