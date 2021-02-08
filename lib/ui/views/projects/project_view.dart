import 'package:flutter/material.dart';
import 'package:portfolio/core/utils/architecture_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'project_view_desktop.dart';
import 'project_view_mobile.dart';
import 'project_view_model.dart';
import 'project_view_tablet.dart';

class ProjectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<ProjectViewModel>(
        viewModel: ProjectViewModel(),
        onModelReady: (m) => m.init(),
        builder: (context, uiHelpers, model) {
          return ScreenTypeLayout(
            desktop: ProjectDesktopView(model: model, uiHelpers: uiHelpers),
            tablet: ProjectTabletView(model: model, uiHelpers: uiHelpers),
            mobile: ProjectMobileView(model: model, uiHelpers: uiHelpers),
          );
        });
  }
}
