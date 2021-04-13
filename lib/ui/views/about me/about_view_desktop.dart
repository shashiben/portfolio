import 'package:flutter/material.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/views/about%20me/about_view_model.dart';
import 'package:portfolio/ui/widgets/divider_widget.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          width: uiHelpers.width * 0.22,
                          child: Divider(
                            color: uiHelpers.dividerColor,
                            thickness: 2.5,
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
                          width: uiHelpers.width * 0.1,
                          child: DividerWidget(
                            width: uiHelpers.width * 0.1,
                            dividerColor: uiHelpers.dividerColor,
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
                          width: uiHelpers.width * 0.1,
                          child: Divider(
                            color: uiHelpers.dividerColor,
                            thickness: 2.5,
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
                        width: uiHelpers.width * 0.08,
                        child: Divider(
                          color: Colors.white60,
                          thickness: 2.5,
                        ),
                      ),
                      Timeline(
                          indicatorColor: uiHelpers.primaryColor,
                          lineColor: uiHelpers.textSecondaryColor,
                          shrinkWrap: true,
                          itemGap: 25,
                          lineGap: 0,
                          
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    EducationDetails.universityStream,
                                    style: uiHelpers.title,
                                  ),
                                  SizedBox(height: 8),
                                  Text(EducationDetails.universityName,
                                      style: uiHelpers.body),
                                  Text(
                                    EducationDetails.universityTimeline,
                                    style: uiHelpers.body,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    EducationDetails.collegeStream,
                                    style: uiHelpers.title,
                                  ),
                                  SizedBox(height: 8),
                                  Text(EducationDetails.collegeName,
                                      style: uiHelpers.body),
                                  Text(
                                    EducationDetails.collegeTimeline,
                                    style: uiHelpers.body,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    EducationDetails.schoolStream,
                                    style: uiHelpers.title,
                                  ),
                                  SizedBox(height: 8),
                                  Text(EducationDetails.schoolName,
                                      style: uiHelpers.body),
                                  Text(
                                    EducationDetails.schoolTimeline,
                                    style: uiHelpers.body,
                                  )
                                ],
                              ),
                            ),
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
