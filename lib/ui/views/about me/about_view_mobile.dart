import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUtils.dart';
import 'package:portfolio/ui/views/about%20me/about_view_model.dart';
import 'package:portfolio/ui/widgets/featured_skill_widget.dart';
import 'package:portfolio/ui/widgets/skill_widget.dart';
import 'package:portfolio/ui/widgets/timeline_widget.dart';

class AboutMobileView extends StatelessWidget {
  final UIHelpers uiHelpers;
  final AboutViewModel model;

  const AboutMobileView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wow, a whole page about my journey!",
                style: uiHelpers.headline.copyWith(fontSize: 26),
              ),
              uiHelpers.verticalSpaceHigh,
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Me,talking about myself",
                      style: uiHelpers.title.copyWith(fontSize: 20),
                    ),
                    Container(
                      width: uiHelpers.width * 0.45,
                      child: Divider(
                        color: Colors.white60,
                        thickness: 2.5,
                      ),
                    ),
                    uiHelpers.verticalSpaceLow,
                    Container(
                      child: Text(PersonalDetails.intro,
                          style: uiHelpers.body.copyWith(
                              color: textSecondaryColor.withOpacity(0.4))),
                    ),
                    uiHelpers.verticalSpaceMedium,
                    Text(
                      "Technical Skills",
                      style: uiHelpers.title.copyWith(fontSize: 24),
                    ),
                    Container(
                      width: uiHelpers.width * 0.4,
                      child: Divider(
                        color: Colors.white60,
                        thickness: 2.5,
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
                      width: uiHelpers.width * 0.4,
                      child: Divider(
                        color: Colors.white60,
                        thickness: 2.5,
                      ),
                    ),
                    FeaturedSkillWidget()
                  ],
                ),
              ),
              uiHelpers.verticalSpaceMedium,
              Text(
                "Education",
                style: uiHelpers.title.copyWith(fontSize: 24),
              ),
              Container(
                width: uiHelpers.width * 0.26,
                child: Divider(
                  color: Colors.white60,
                  thickness: 2.5,
                ),
              ),
              Timeline(
                  indicatorColor: primaryColor,
                  lineColor: textSecondaryColor,
                  shrinkWrap: true,
                  itemGap: 25,
                  lineGap: 5,
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
          ),
        ),
      ),
    );
  }
}
