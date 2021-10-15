import 'package:flutter/material.dart';

import '../../../core/utils/architecture_view.dart';
import 'project_view_model.dart';
import 'project_view_responsive.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({Key? key}) : super(key: key);

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
