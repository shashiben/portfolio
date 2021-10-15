import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../../app/configs.dart';
import '../../../app/icons.dart';
import '../../../core/utils/ScreenUiHelper.dart';
import '../../widgets/icon_wrapper.dart';
import '../../widgets/translate_on_hover.dart';

import 'home_view_model.dart';

class HomeDesktopView extends StatelessWidget {
  final ScreenUiHelper? uiHelpers;
  final HomeViewModel? model;

  const HomeDesktopView({Key? key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: uiHelpers!.backgroundColor,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(60),
          child: Neumorphic(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            style: NeumorphicStyle(
              color: uiHelpers!.surfaceColor,
              depth: NeumorphicTheme.embossDepth(context),
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/sk_logo.png',
                          width: 50,
                          height: 50,
                          color: uiHelpers!.textPrimaryColor,
                        ),
                        Text(
                          'Shashi Kumar',
                          style: uiHelpers!.title,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        TranslateOnHover(
                          child: TextButton(
                              onPressed: () => model!
                                  .navigateToUrl(PersonalDetails.resumeLink),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Resume',
                                  style: uiHelpers!.title,
                                ),
                              )),
                        ),
                        TranslateOnHover(
                          child: TextButton(
                              onPressed: () => model!
                                  .navigateToUrl(PersonalDetails.whatsappLink),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Contact',
                                  style: uiHelpers!.title,
                                ),
                              )),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: uiHelpers!.width! * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: model!.skills.keys
                          .map((e) => Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                width: uiHelpers!.width! * 0.28,
                                child: Neumorphic(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.concave,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(12)),
                                      depth: 8,
                                      intensity: 0.6,
                                      color: uiHelpers!.surfaceColor),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Neumorphic(
                                          style: NeumorphicStyle(
                                            depth: NeumorphicTheme.embossDepth(
                                                context),
                                            boxShape: const NeumorphicBoxShape
                                                .circle(),
                                          ),
                                          child: Image.asset(
                                            model!.skills[e]!,
                                            width: 40,
                                            height: 40,
                                          )),
                                      const SizedBox(width: 10),
                                      Text(
                                        e,
                                        style: uiHelpers!.title,
                                      )
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: uiHelpers!.width! * 0.3,
                          child: Text(
                            PersonalDetails.shortIntro,
                            style: uiHelpers!.body!.copyWith(
                                fontWeight: FontWeight.w400,
                                height: 2,
                                color: uiHelpers!.textPrimaryColor),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        IconWrrapper(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          onTap: () =>
                              model!.navigateToUrl(SocialLinks.githubLink),
                          child: Row(
                            children: [
                              Icon(
                                ContactIcons.githubIcon,
                                color: uiHelpers!.textPrimaryColor,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Github',
                                style: uiHelpers!.buttonStyle,
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
