import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
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
          child: Material(
            color: surfaceColor,
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
                      Icon(ProjectIcons.folderIcon, size: 30),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          project.websiteLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(ProjectIcons.websiteIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.websiteLink),
                                ),
                          project.githubLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(ProjectIcons.githubIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.githubLink),
                                ),
                          project.playstoreLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(ProjectIcons.playstoreIcon),
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
                                color: Color(0xFF8892B0)),
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
          margin: EdgeInsets.only(
              bottom: 15, right: uiHelpers.width > 768 ? 15 : 0),
          child: Material(
            color: surfaceColor,
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
                      Icon(ProjectIcons.folderIcon, size: 30),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          project.websiteLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(ProjectIcons.websiteIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.websiteLink),
                                ),
                          project.githubLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(ProjectIcons.githubIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.githubLink),
                                ),
                          project.playstoreLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(ProjectIcons.playstoreIcon),
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
                                color: Color(0xFF8892B0)),
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
            color: surfaceColor,
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
                      Icon(ProjectIcons.folderIcon, size: 30),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          project.websiteLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(ProjectIcons.websiteIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.websiteLink),
                                ),
                          project.githubLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(ProjectIcons.githubIcon),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.githubLink),
                                ),
                          project.playstoreLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(ProjectIcons.playstoreIcon),
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
                                color: Color(0xFF8892B0)),
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
