import 'package:flutter/material.dart';
import 'package:portfolio/core/utils/architecture_view.dart';

import 'experience_view_model.dart';

class ExperienceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<ExperienceViewModel>(
      viewModel: ExperienceViewModel(),
      onModelReady: (m) => m.init(),
      builder: (context, uiHelpers, model) => Scaffold(
        body: Container(
          width: uiHelpers.width,
          height: uiHelpers.height,
          child: Container(
            padding: const EdgeInsets.only(left: 40).copyWith(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Experience",
                  style: uiHelpers.headline,
                ),
                uiHelpers.verticalSpaceMedium,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
