import 'package:flutter/material.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';

import 'linear_percent_indicator.dart';

class FeaturedSkillWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiHelpers = ScreenUiHelper.fromContext(context);
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: PersonalDetails.featuredSkills.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Container(
              width: uiHelpers.width! * 0.8,
              child: LinearPercentIndicator(
                progressColor: uiHelpers.primaryColor,
                title: PersonalDetails.featuredSkills[index].name,
                percent:
                    PersonalDetails.featuredSkills[index].percent.toDouble() /
                        100,
              ),
            ));
  }
}
