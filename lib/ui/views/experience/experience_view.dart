import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/utils/architecture_view.dart';
import 'experience_desktop_view.dart';
import 'experience_view_mobile.dart';
import 'experience_view_model.dart';

class ExperienceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<ExperienceViewModel>(
        viewModel: ExperienceViewModel(),
        onModelReady: (m) => m.init(),
        builder: (context, uiHelpers, model) => ScreenTypeLayout(
              desktop:
                  ExperienceDesktopView(model: model, uiHelpers: uiHelpers),
              tablet: ExperienceMobileView(
                uiHelpers: uiHelpers,
                model: model,
              ),
              mobile: ExperienceMobileView(
                uiHelpers: uiHelpers,
                model: model,
              ),
            ));
  }
}
