import 'package:flutter/material.dart';
import 'package:portfolio/core/utils/architecture_view.dart';

import 'project_view_responsive.dart';
import 'project_view_model.dart';

class ProjectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<ProjectViewModel>(
        viewModel: ProjectViewModel(),
        onModelReady: (m) => m.init(),
        builder: (context, uiHelpers, model) {
          return ProjectResponsiveView(
            uiHelpers: uiHelpers,
            model: model,
          );
        });
  }
}
