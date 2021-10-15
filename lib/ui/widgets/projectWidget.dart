import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../app/icons.dart';
import '../../core/models/project.dart';
import '../../core/services/url_launcher_service.dart';
import '../../core/utils/ScreenUiHelper.dart';
import 'fadeAnimation.dart';
import 'translate_on_hover.dart';

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
                    children: [
                      Icon(
                        ProjectIcons.folderIcon,
                        color: uiHelpers.primaryColor,
                        size: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (project.websiteLink == null) const SizedBox() else IconButton(
                                  icon: Icon(
                                    ProjectIcons.websiteIcon,
                                    color: uiHelpers.primaryColor,
                                  ),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.websiteLink!),
                                ),
                          if (project.githubLink == null) const SizedBox() else IconButton(
                                  icon: Icon(
                                    ProjectIcons.githubIcon,
                                    color: uiHelpers.primaryColor,
                                  ),
                                  onPressed: () => _urlLauncherService
                                      .launchUrl(project.githubLink!),
                                ),
                          if (project.playstoreLink == null) const SizedBox() else IconButton(
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
                    style:
                        uiHelpers.body!.copyWith(fontWeight: FontWeight.w300),
                  ),
                  const Spacer(),
                  Wrap(
                    children: [
                      for (int i = 0; i < project.tools.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4)
                              .copyWith(right: 16),
                          child: Text(
                            project.tools[i],
                            style: uiHelpers.body!.copyWith(
                                fontWeight: FontWeight.w400,
                                color: uiHelpers.textSecondaryColor),
                          ),
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
