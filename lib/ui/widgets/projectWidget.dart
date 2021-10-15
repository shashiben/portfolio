import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/models/project.dart';
import 'package:portfolio/core/services/url_launcher_service.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/widgets/translate_on_hover.dart';

import 'fadeAnimation.dart';

class ProjectWidget extends StatelessWidget {
  final String? type;
  final int index;
  final Project project;

  const ProjectWidget(
      {Key? key, this.type, required this.index, required this.project})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UrlLauncherService _urlLauncherService = UrlLauncherService();
    final ScreenUiHelper uiHelpers = ScreenUiHelper.fromContext(context);
    return FadeAnimation(
      xDistance: 0,
      yDistance: 0000000,
      delay: index * 0.2 + 1,
      child: TranslateOnHover(
        child: Container(
          height: 250,
          margin: EdgeInsets.only(
              bottom: 15, right: uiHelpers.width! > 768 ? 15 : 0),
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
              width: uiHelpers.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        ProjectIcons.folderIcon,
                        color: uiHelpers.primaryColor,
                        size: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          project.websiteLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(
                                    ProjectIcons.websiteIcon,
                                    color: uiHelpers.primaryColor,
                                  ),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.websiteLink!),
                                ),
                          project.githubLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(
                                    ProjectIcons.githubIcon,
                                    color: uiHelpers.primaryColor,
                                  ),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.githubLink!),
                                ),
                          project.playstoreLink == null
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(
                                    ProjectIcons.playstoreIcon,
                                    color: uiHelpers.primaryColor,
                                  ),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.playstoreLink!),
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
                    style: uiHelpers.body!.copyWith(fontWeight: FontWeight.w300),
                  ),
                  Spacer(),
                  Wrap(
                    children: [
                      for (int i = 0; i < project.tools.length; i++)
                        Padding(
                          child: Text(
                            project.tools[i],
                            style: uiHelpers.body!.copyWith(
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
