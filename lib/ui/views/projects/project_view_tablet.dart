import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/views/projects/project_view_model.dart';
import 'package:portfolio/ui/widgets/grid_view_widget.dart';
import 'package:portfolio/ui/widgets/projectWidget.dart';

class ProjectTabletView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final ProjectViewModel model;

  const ProjectTabletView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                uiHelpers.verticalSpaceHigh,
                Text(
                  "Some Things I’ve Built",
                  style: uiHelpers.headline.copyWith(fontSize: 45),
                ),
                Container(
                  width: uiHelpers.width * 0.40,
                  child: Divider(
                    color: dividerColor,
                    thickness: 2.5,
                  ),
                ),
                uiHelpers.verticalSpaceHigh,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50),
                            child: ResponsiveGridRow(
                              children: [
                                for (int i = 0; i < 10; i++)
                                  ResponsiveGridCol(
                                    child: ProjectWidget(),
                                    xl: 4,
                                  )
                              ],
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
