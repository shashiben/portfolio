import 'package:flutter/material.dart';
import 'package:portfolio/core/utils/architecture_view.dart';
import 'package:portfolio/ui/widgets/projectWidget.dart';

import 'project_view_model.dart';

class ProjectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<ProjectViewModel>(
      viewModel: ProjectViewModel(),
      onModelReady: (m) => m.init(),
      builder: (context, uiHelpers, model) => Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 30, left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Projects", style: uiHelpers.headline),
              uiHelpers.verticalSpaceMedium,
              Expanded(
                child: GridView.builder(
                    itemCount: 10,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return ProjectWidget();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
