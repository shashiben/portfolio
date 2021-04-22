import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/views/projects/project_view_model.dart';
import 'package:portfolio/ui/widgets/grid_view_widget.dart';

class ProjectResponsiveView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final ProjectViewModel model;

  const ProjectResponsiveView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiHelpers.backgroundColor,
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
                Text("Some Things I’ve Built", style: uiHelpers.headline),
                Container(
                  width: uiHelpers.width * 0.25,
                  child: Divider(
                    color: uiHelpers.dividerColor,
                    thickness: 2.5,
                  ),
                ),
                uiHelpers.verticalSpaceHigh,
                NeumorphicToggle(
                  width: uiHelpers.width * 1.2,
                  movingCurve: Curves.linearToEaseOut,
                  style: NeumorphicToggleStyle(
                      backgroundColor: uiHelpers.surfaceColor),
                  onChanged: (value) => model.changeIndex(value),
                  children: [
                    ToggleElement(
                        foreground: Center(
                            child: Text(
                          "All",
                          style: uiHelpers.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: SystemProperties.titleFont),
                          textAlign: TextAlign.center,
                        )),
                        background: Center(
                          child: Text(
                            "All",
                            style: uiHelpers.body,
                            textAlign: TextAlign.center,
                          ),
                        )),
                    ToggleElement(
                        foreground: Center(
                            child: Text(
                          "Apps",
                          style: uiHelpers.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: SystemProperties.titleFont),
                          textAlign: TextAlign.center,
                        )),
                        background: Center(
                            child: Text(
                          "Apps",
                          style: uiHelpers.body,
                          textAlign: TextAlign.center,
                        ))),
                    ToggleElement(
                        foreground: Center(
                            child: Text(
                          "Web Apps",
                          style: uiHelpers.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: SystemProperties.titleFont),
                          textAlign: TextAlign.center,
                        )),
                        background: Center(
                            child: Text(
                          "Web Apps",
                          style: uiHelpers.body,
                          textAlign: TextAlign.center,
                        ))),
                    ToggleElement(
                        foreground: Center(
                            child: Text(
                          "Others",
                          style: uiHelpers.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: SystemProperties.titleFont),
                          textAlign: TextAlign.center,
                        )),
                        background: Center(
                            child: Text(
                          "Others",
                          style: uiHelpers.body,
                          textAlign: TextAlign.center,
                        )))
                  ],
                  thumb: SizedBox(),
                  selectedIndex: model.index,
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: ResponsiveGridRow(
                          children: model.getProjects(),
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
