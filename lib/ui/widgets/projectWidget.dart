import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/ScreenUtils.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ProjectWidget extends StatelessWidget {
  final String type;

  const ProjectWidget({Key key, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UIHelpers uiHelpers = UIHelpers.fromContext(context);
    return ScreenTypeLayout(
      desktop: Container(
        margin:
            EdgeInsets.only(bottom: 15, right: uiHelpers.width > 768 ? 15 : 0),
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
                        IconButton(
                          icon: Icon(ProjectIcons.websiteIcon),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(ProjectIcons.githubIcon),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(ProjectIcons.playstoreIcon),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                uiHelpers.verticalSpaceMedium,
                Text(
                  "Integrating Algolia Search with WordPress Multisite",
                  style: uiHelpers.title,
                ),
                uiHelpers.verticalSpaceLow,
                Text(
                  "Embeddable web player widget for Apple Music that lets users log in and listen to full song playback in the browser leveraging MusicKit.js. Read more about this project on 9to5Mac.",
                  style: uiHelpers.body.copyWith(fontWeight: FontWeight.w300),
                ),
                uiHelpers.verticalSpaceLow,
                Wrap(
                  children: [
                    for (int i = 0; i < 7; i++)
                      Padding(
                        child: Text(
                          "Firebase",
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
      tablet: Container(
        margin:
            EdgeInsets.only(bottom: 15, right: uiHelpers.width > 768 ? 15 : 0),
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
                        IconButton(
                          icon: Icon(ProjectIcons.websiteIcon),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(ProjectIcons.githubIcon),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(ProjectIcons.playstoreIcon),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                uiHelpers.verticalSpaceMedium,
                Text(
                  "Integrating Algolia Search with WordPress Multisite",
                  style: uiHelpers.title,
                ),
                uiHelpers.verticalSpaceLow,
                Text(
                  "Embeddable web player widget for Apple Music that lets users log in and listen to full song playback in the browser leveraging MusicKit.js. Read more about this project on 9to5Mac.",
                  style: uiHelpers.body.copyWith(fontWeight: FontWeight.w300),
                ),
                uiHelpers.verticalSpaceLow,
                Wrap(
                  children: [
                    for (int i = 0; i < 7; i++)
                      Padding(
                        child: Text(
                          "Firebase",
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
      mobile: Container(
        margin:
            EdgeInsets.only(bottom: 15, right: uiHelpers.width > 768 ? 15 : 0),
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
                        IconButton(
                          icon: Icon(ProjectIcons.websiteIcon),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(ProjectIcons.githubIcon),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(ProjectIcons.playstoreIcon),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                uiHelpers.verticalSpaceMedium,
                Text(
                  "Integrating Algolia Search with WordPress Multisite",
                  style: uiHelpers.title,
                ),
                uiHelpers.verticalSpaceLow,
                Text(
                  "Embeddable web player widget for Apple Music that lets users log in and listen to full song playback in the browser leveraging MusicKit.js. Read more about this project on 9to5Mac.",
                  style: uiHelpers.body.copyWith(fontWeight: FontWeight.w300),
                ),
                uiHelpers.verticalSpaceLow,
                Wrap(
                  children: [
                    for (int i = 0; i < 7; i++)
                      Padding(
                        child: Text(
                          "Firebase",
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
    );
  }
}
