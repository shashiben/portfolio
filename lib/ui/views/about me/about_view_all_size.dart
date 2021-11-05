import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';

import '../../../app/configs.dart';
import '../../../core/utils/ScreenUiHelper.dart';
import '../../widgets/divider_widget.dart';
import '../../widgets/eductaion_timeline_widget.dart';
import '../../widgets/featured_skill_widget.dart';
import '../../widgets/skill_widget.dart';
import '../../widgets/timeline_widget.dart';
import 'about_view_model.dart';

class AboutViewResponsive extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final AboutViewModel model;

  const AboutViewResponsive(
      {Key? key, required this.uiHelpers, required this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkColor.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Wow, a whole page about my journey!',
                style: uiHelpers.headline,
              ),
            ),
            const SizedBox(height: 80),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Me,talking about myself',
                            style: uiHelpers.title.copyWith(fontSize: 24),
                          ),
                          SizedBox(
                            width: 80,
                            child: DividerWidget(
                              width: 80,
                              dividerColor: uiHelpers.primaryColor,
                            ),
                          ),
                          uiHelpers.verticalSpaceLow,
                          Text(PersonalDetails.intro,
                              style: uiHelpers.body.copyWith(
                                  color: uiHelpers.textSecondaryColor)),
                          uiHelpers.verticalSpaceMedium,
                          Text(
                            'Technical Skills',
                            style: uiHelpers.title.copyWith(fontSize: 24),
                          ),
                          SizedBox(
                            width: 70,
                            child: DividerWidget(
                              width: 70,
                              dividerColor: uiHelpers.primaryColor,
                            ),
                          ),
                          uiHelpers.verticalSpaceLow,
                          const SkillWidget(),
                          uiHelpers.verticalSpaceMedium,
                          Text(
                            'Featured Skills',
                            style: uiHelpers.title.copyWith(fontSize: 24),
                          ),
                          SizedBox(
                            width: 75,
                            child: DividerWidget(
                              width: 75,
                              dividerColor: uiHelpers.primaryColor,
                            ),
                          ),
                          uiHelpers.verticalSpaceLow,
                          const FeaturedSkillWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Education',
                        style: uiHelpers.title.copyWith(fontSize: 24),
                      ),
                      SizedBox(
                        width: 70,
                        child: DividerWidget(
                          width: 70,
                          dividerColor: uiHelpers.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Timeline(
                          indicatorSize: 16,
                          indicatorColor: uiHelpers.primaryColor,
                          lineColor: uiHelpers.textPrimaryColor,
                          shrinkWrap: true,
                          itemGap: 25,
                          lineGap: 0,
                          children: const [
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
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
