import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/views/projects/project_view_model.dart';
import 'package:portfolio/ui/widgets/grid_view_widget.dart';

class ProjectDesktopView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final ProjectViewModel model;

  const ProjectDesktopView({Key key, this.uiHelpers, this.model})
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
                Text(
                  "Some Things I’ve Built",
                  style: uiHelpers.headline.copyWith(fontSize: 45),
                ),
                Container(
                  width: uiHelpers.width * 0.25,
                  child: Divider(
                    color: uiHelpers.dividerColor,
                    thickness: 2.5,
                  ),
                ),
                uiHelpers.verticalSpaceHigh,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: NeumorphicToggle(
                    movingCurve: Curves.linearToEaseOut,
                    style: NeumorphicToggleStyle(
                        backgroundColor: uiHelpers.surfaceColor),
                    onChanged: (value) => model.changeIndex(value),
                    children: [
                      ToggleElement(
                          foreground: Center(child: Text("All")),
                          background: Center(
                            child: Text("All"),
                          )),
                      ToggleElement(
                          foreground:
                              Center(child: Text("Mobile Applications")),
                          background: Center(child: Text("Applications"))),
                      ToggleElement(
                          foreground: Center(child: Text("Web Applications")),
                          background: Center(child: Text("Web Applications"))),
                      ToggleElement(
                          foreground: Center(child: Text("Others")),
                          background: Center(child: Text("Others")))
                    ],
                    thumb: SizedBox(),
                    selectedIndex: model.index,
                  ),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
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
