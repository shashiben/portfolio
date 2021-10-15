import 'package:flutter/material.dart';
import '../../app/configs.dart';
import '../../core/utils/ScreenUiHelper.dart';

import 'linear_percent_indicator.dart';

class FeaturedSkillWidget extends StatelessWidget {
  const FeaturedSkillWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiHelpers = ScreenUiHelper.fromContext(context);
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: PersonalDetails.featuredSkills.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => SizedBox(
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
