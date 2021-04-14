import 'package:flutter/material.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/views/about%20me/about_view_model.dart';
import 'package:portfolio/ui/widgets/divider_widget.dart';
import 'package:portfolio/ui/widgets/eductaion_timeline_widget.dart';
import 'package:portfolio/ui/widgets/featured_skill_widget.dart';
import 'package:portfolio/ui/widgets/skill_widget.dart';
import 'package:portfolio/ui/widgets/timeline_widget.dart';

class AboutDesktopView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final AboutViewModel model;

  const AboutDesktopView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiHelpers.backgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Wow, a whole page about my journey!",
                style: uiHelpers.headline.copyWith(fontSize: 50),
              ),
              uiHelpers.verticalSpaceHigh,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: uiHelpers.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Me,talking about myself",
                          style: uiHelpers.title.copyWith(fontSize: 24),
                        ),
                        Container(
                          width: uiHelpers.width * 0.1,
                          child: DividerWidget(
                            width: uiHelpers.width * 0.1,
                            dividerColor: uiHelpers.primaryColor,
                          ),
                        ),
                        uiHelpers.verticalSpaceLow,
                        Container(
                          width: uiHelpers.width * 0.45,
                          child: Text(PersonalDetails.intro,
                              style: uiHelpers.body.copyWith(
                                  color: uiHelpers.textSecondaryColor)),
                        ),
                        uiHelpers.verticalSpaceMedium,
                        Text(
                          "Technical Skills",
                          style: uiHelpers.title.copyWith(fontSize: 24),
                        ),
                        Container(
                          width: uiHelpers.width * 0.07,
                          child: DividerWidget(
                            width: uiHelpers.width * 0.1,
                            dividerColor: uiHelpers.primaryColor,
                          ),
                        ),
                        uiHelpers.verticalSpaceLow,
                        SkillWidget(),
                        uiHelpers.verticalSpaceMedium,
                        Text(
                          "Featured Skills",
                          style: uiHelpers.title.copyWith(fontSize: 24),
                        ),
                        Container(
                          width: uiHelpers.width * 0.05,
                          child: DividerWidget(
                            width: uiHelpers.width * 0.1,
                            dividerColor: uiHelpers.primaryColor,
                          ),
                        ),
                        uiHelpers.verticalSpaceLow,
                        FeaturedSkillWidget(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: uiHelpers.width * 0.08,
                  ),
                  Expanded(
                      child: Container(
                          child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Education",
                        style: uiHelpers.title.copyWith(fontSize: 24),
                      ),
                      Container(
                        width: uiHelpers.width * 0.04,
                        child: DividerWidget(
                          width: uiHelpers.width * 0.03,
                          dividerColor: uiHelpers.primaryColor,
                        ),
                      ),
                      SizedBox(height: 15),
                      Timeline(
                          indicatorColor: uiHelpers.primaryColor,
                          lineColor: uiHelpers.textSecondaryColor,
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
                                percentage: EducationDetails.collegePercentage),
                            EducationDetailsTimelineWidget(
                                name: EducationDetails.schoolName,
                                stream: EducationDetails.schoolStream,
                                year: EducationDetails.schoolTimeline,
                                percentage: EducationDetails.schoolPercentage),
                          ])
                    ],
                  )))
                ],
              ),
              uiHelpers.verticalSpaceMedium,
            ],
          ),
        ),
      ),
    );
  }
}
