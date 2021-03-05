import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/views/projects/project_view_model.dart';
import 'package:portfolio/ui/widgets/grid_view_widget.dart';

class ProjectMobileView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final ProjectViewModel model;

  const ProjectMobileView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                uiHelpers.verticalSpaceHigh,
                Text(
                  "Some Things I’ve Built",
                  style: uiHelpers.headline.copyWith(fontSize: 24),
                ),
                Container(
                  width: uiHelpers.width * 0.45,
                  child: Divider(
                    color: dividerColor,
                    thickness: 2.5,
                  ),
                ),
                uiHelpers.verticalSpaceLow,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ResponsiveGridRow(
                              children: model.list,
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
