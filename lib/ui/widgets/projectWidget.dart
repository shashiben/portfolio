import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/models/project.dart';
import 'package:portfolio/core/services/url_launcher_service.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'fadeAnimation.dart';

class ProjectWidget extends StatelessWidget {
  final String type;
  final int index;
  final Project project;

  const ProjectWidget(
      {Key key, this.type, @required this.index, @required this.project})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UrlLauncherService _urlLauncherService = UrlLauncherService();
    final ScreenUiHelper uiHelpers = ScreenUiHelper.fromContext(context);
    return ScreenTypeLayout(
      desktop: FadeAnimation(
        xDistance: 0,
        yDistance: 0000000,
        delay: index * 0.2 + 1,
        child: Container(
          height: 250,
          margin: EdgeInsets.only(
              bottom: 15, right: uiHelpers.width > 768 ? 15 : 0),
          child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                shadowLightColor: uiHelpers.backgroundColor,
                depth: 5,
                intensity: 0.6,
                color: uiHelpers.backgroundColor,
                surfaceIntensity: 0.3,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12))),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      NeumorphicIcon(
                        ProjectIcons.folderIcon,
                        size: 30,
                        style: NeumorphicStyle(
                            surfaceIntensity: 0.1,
                            intensity: 0.3,
                            color: uiHelpers.primaryColor),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          project.websiteLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: NeumorphicIcon(
                                    ProjectIcons.websiteIcon,
                                    style: NeumorphicStyle(
                                        surfaceIntensity: 0.1,
                                        intensity: 0.3,
                                        color: uiHelpers.primaryColor),
                                  ),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.websiteLink),
                                ),
                          project.githubLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: NeumorphicIcon(
                                    ProjectIcons.githubIcon,
                                    style: NeumorphicStyle(
                                        surfaceIntensity: 0.1,
                                        intensity: 0.3,
                                        color: uiHelpers.primaryColor),
                                  ),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.githubLink),
                                ),
                          project.playstoreLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: NeumorphicIcon(
                                    ProjectIcons.playstoreIcon,
                                    style: NeumorphicStyle(
                                        surfaceIntensity: 0.1,
                                        intensity: 0.3,
                                        color: uiHelpers.primaryColor),
                                  ),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.playstoreLink),
                                ),
                        ],
                      ),
                    ],
                  ),
                  uiHelpers.verticalSpaceMedium,
                  Text(
                    project.title,
                    style: uiHelpers.title,
                  ),
                  uiHelpers.verticalSpaceLow,
                  Text(
                    project.description,
                    style: uiHelpers.body.copyWith(fontWeight: FontWeight.w300),
                  ),
                  Spacer(),
                  Wrap(
                    children: [
                      for (int i = 0; i < project.tools.length; i++)
                        Padding(
                          child: Text(
                            project.tools[i],
                            style: uiHelpers.body.copyWith(
                                fontWeight: FontWeight.w400,
                                color: uiHelpers.textSecondaryColor),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4)
                              .copyWith(right: 16),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      tablet: FadeAnimation(
        delay: index * 0.2 + 1,
        xDistance: 0,
        child: Container(
          height: 250,
          margin: EdgeInsets.only(
              bottom: 15, right: uiHelpers.width > 768 ? 15 : 0),
          child: Material(
            color: uiHelpers.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      NeumorphicIcon(ProjectIcons.folderIcon, size: 30),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          project.websiteLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: NeumorphicIcon(
                                    ProjectIcons.websiteIcon,
                                  ),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.websiteLink),
                                ),
                          project.githubLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: NeumorphicIcon(ProjectIcons.githubIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.githubLink),
                                ),
                          project.playstoreLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: NeumorphicIcon(
                                      ProjectIcons.playstoreIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.playstoreLink),
                                ),
                        ],
                      ),
                    ],
                  ),
                  uiHelpers.verticalSpaceMedium,
                  Text(
                    project.title,
                    style: uiHelpers.title,
                  ),
                  uiHelpers.verticalSpaceLow,
                  Text(
                    project.description,
                    style: uiHelpers.body.copyWith(fontWeight: FontWeight.w300),
                  ),
                  uiHelpers.verticalSpaceLow,
                  Wrap(
                    children: [
                      for (int i = 0; i < project.tools.length; i++)
                        Padding(
                          child: Text(
                            project.tools[i],
                            style: uiHelpers.body.copyWith(
                                fontWeight: FontWeight.w400,
                                color: uiHelpers.textSecondaryColor),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4)
                              .copyWith(right: 16),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      mobile: FadeAnimation(
        delay: index * 0.2 + 1,
        xDistance: 0,
        child: Container(
          margin: EdgeInsets.only(
              bottom: 15, right: uiHelpers.width > 768 ? 15 : 0),
          child: Material(
            color: uiHelpers.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      NeumorphicIcon(ProjectIcons.folderIcon, size: 30),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          project.websiteLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon:
                                      NeumorphicIcon(ProjectIcons.websiteIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.websiteLink),
                                ),
                          project.githubLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: NeumorphicIcon(ProjectIcons.githubIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.githubLink),
                                ),
                          project.playstoreLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: NeumorphicIcon(
                                      ProjectIcons.playstoreIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.playstoreLink),
                                ),
                        ],
                      ),
                    ],
                  ),
                  uiHelpers.verticalSpaceMedium,
                  Text(
                    project.title,
                    style: uiHelpers.title,
                  ),
                  uiHelpers.verticalSpaceLow,
                  Text(
                    project.description,
                    style: uiHelpers.body.copyWith(fontWeight: FontWeight.w300),
                  ),
                  uiHelpers.verticalSpaceLow,
                  Wrap(
                    children: [
                      for (int i = 0; i < project.tools.length; i++)
                        Padding(
                          child: Text(
                            project.tools[i],
                            style: uiHelpers.body.copyWith(
                                fontWeight: FontWeight.w400,
                                color: uiHelpers.textSecondaryColor),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4)
                              .copyWith(right: 16),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
