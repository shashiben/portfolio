import 'dart:math';

import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../app/configs.dart';
import '../../../app/icons.dart';
import '../../../core/utils/architecture_view.dart';
import '../../widgets/flicker_text_animation.dart';
import '../../widgets/icon_switch.dart';
import '../../widgets/icon_wrapper.dart';
import 'main_view_model.dart';

class MainView extends HookWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconController =
        useAnimationController(duration: const Duration(milliseconds: 700));
    final menuAnimationController =
        useAnimationController(duration: const Duration(milliseconds: 700));
    final menuTextController =
        useAnimationController(duration: const Duration(milliseconds: 1200));
    final offset = Tween(end: Offset.zero, begin: const Offset(1, 0))
        .animate(menuAnimationController);

    return ScreenBuilder<MainViewModel>(
        onModelReady: (m) => m.init(),
        viewModel: MainViewModel(),
        builder: (context, uiHelpers, model) => Scaffold(
              backgroundColor: uiHelpers.backgroundColor,
              floatingActionButton: (model.isMobile(context) || model.isIndex3)
                  ? const SizedBox()
                  : AnimatedOpacity(
                      opacity: model.isIndex3 ? 0 : 1,
                      duration: const Duration(milliseconds: 700),
                      child: FloatingActionButton(
                        backgroundColor: uiHelpers.primaryColor,
                        onPressed: () {},
                        child: AnimateIcons(
                          startIcon: NeumorphicTheme.of(context)!.isUsingDark
                              ? MenuIcons.sunIcon
                              : MenuIcons.moonIcon,
                          size: 30.0,
                          controller: AnimateIconController(),
                          startTooltip: NeumorphicTheme.of(context)!.isUsingDark
                              ? 'Dark Mode'
                              : 'Light Mode',
                          endTooltip: !NeumorphicTheme.of(context)!.isUsingDark
                              ? 'Dark Mode'
                              : 'Light Mode',
                          onStartIconPress: () {
                            NeumorphicTheme.of(context)!.themeMode =
                                NeumorphicTheme.of(context)!.isUsingDark
                                    ? ThemeMode.light
                                    : ThemeMode.dark;
                            return true;
                          },
                          onEndIconPress: () {
                            print(NeumorphicTheme.of(context)!.isUsingDark);
                            NeumorphicTheme.of(context)!.themeMode =
                                ThemeMode.dark;

                            return true;
                          },
                          duration: const Duration(milliseconds: 500),
                          startIconColor: Colors.deepPurple,
                          endIconColor: Colors.deepOrange,
                          clockwise: false,
                        ),
                      ),
                    ),
              body: ScreenTypeLayout(
                desktop: CollapsibleSidebar(
                    selectedIconColor: NeumorphicTheme.of(context)!.isUsingDark
                        ? uiHelpers.primaryColor!
                        : Colors.white,
                    maxWidth: 250,
                    avatarImg: const AssetImage('assets/images/s.jpg'),
                    topPadding: 50,
                    body: model.child,
                    title: 'Shashi Kumar',
                    items: model.collapsibleItem),
                tablet: CollapsibleSidebar(
                    maxWidth: 250,
                    avatarImg: const AssetImage('assets/images/s.jpg'),
                    topPadding: 50,
                    body: model.child,
                    title: 'Shashi Kumar',
                    items: model.collapsibleItem),
                mobile: SizedBox(
                  width: uiHelpers.width,
                  height: uiHelpers.height,
                  child: Stack(
                    children: [
                      Row(
                        children: <Widget>[
                          Container(
                            color: uiHelpers.surfaceColor,
                            width: uiHelpers.width! * 0.14,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 20),
                                  child: IconButton(
                                    icon: AnimatedIcon(
                                      icon: AnimatedIcons.menu_close,
                                      progress: iconController,
                                      color: uiHelpers.primaryColor,
                                    ),
                                    onPressed: () => model.changeMenuForMobile(
                                        iconController,
                                        menuAnimationController,
                                        menuTextController),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 120,
                                  child: VerticalDivider(
                                    width: 10,
                                    color: uiHelpers.dividerColor,
                                    thickness: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                IconWrrapper(
                                    margin: const EdgeInsets.all(0),
                                    boxShape: const NeumorphicBoxShape.circle(),
                                    padding: const EdgeInsets.all(4),
                                    onTap: () =>
                                        model.openUrl(SocialLinks.facebookLink),
                                    child: Icon(ContactIcons.facebookIcon,
                                        size: 20,
                                        color: uiHelpers.textPrimaryColor)),
                                const SizedBox(
                                  height: 15,
                                ),
                                IconWrrapper(
                                    margin: const EdgeInsets.all(0),
                                    boxShape: const NeumorphicBoxShape.circle(),
                                    padding: const EdgeInsets.all(8),
                                    onTap: () => model
                                        .openUrl(SocialLinks.instagramLink),
                                    child: Icon(ContactIcons.instagramIcon,
                                        size: 20,
                                        color: uiHelpers.textPrimaryColor)),
                                const SizedBox(
                                  height: 15,
                                ),
                                IconWrrapper(
                                    margin: const EdgeInsets.all(0),
                                    boxShape: const NeumorphicBoxShape.circle(),
                                    padding: const EdgeInsets.all(4),
                                    onTap: () =>
                                        model.openUrl(SocialLinks.telegramLink),
                                    child: Icon(ContactIcons.telegramIcon,
                                        size: 20,
                                        color: uiHelpers.textPrimaryColor)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AnimateIcons(
                                    startIcon:
                                        NeumorphicTheme.of(context)!.isUsingDark
                                            ? MenuIcons.sunIcon
                                            : MenuIcons.moonIcon,
                                    size: 30.0,
                                    controller: AnimateIconController(),
                                    startTooltip:
                                        NeumorphicTheme.of(context)!.isUsingDark
                                            ? 'Dark Mode'
                                            : 'Light Mode',
                                    endTooltip: !NeumorphicTheme.of(context)!
                                            .isUsingDark
                                        ? 'Dark Mode'
                                        : 'Light Mode',
                                    onStartIconPress: () {
                                      NeumorphicTheme.of(context)!.themeMode =
                                          NeumorphicTheme.of(context)!
                                                  .isUsingDark
                                              ? ThemeMode.light
                                              : ThemeMode.dark;
                                      return true;
                                    },
                                    onEndIconPress: () {
                                      print(NeumorphicTheme.of(context)!
                                          .isUsingDark);
                                      NeumorphicTheme.of(context)!.themeMode =
                                          ThemeMode.dark;

                                      return true;
                                    },
                                    duration: const Duration(milliseconds: 500),
                                    startIconColor: Colors.deepPurple,
                                    endIconColor: Colors.deepOrange,
                                    clockwise: false,
                                  ),
                                )
                              ],
                            ),
                          ),
                          VerticalDivider(
                            thickness: 1,
                            width: 1,
                            color: uiHelpers.dividerColor,
                          ),
                          Expanded(
                            child: PageView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                onPageChanged: (index) =>
                                    model.changeIndex(index),
                                scrollDirection: Axis.vertical,
                                controller: model.pageController,
                                itemBuilder: (context, index) =>
                                    model.views[model.index]),
                          )
                        ],
                      ),
                      SizedBox(
                        height: uiHelpers.height,
                        width: uiHelpers.width,
                        child: SlideTransition(
                            position: offset,
                            child: Row(children: [
                              Container(width: uiHelpers.width! * 0.14),
                              Expanded(
                                child: Container(
                                  height: uiHelpers.height,
                                  decoration: BoxDecoration(
                                      color: uiHelpers.surfaceColor),
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: model.menuItems
                                            .map((e) => ListTile(
                                                  title: Center(
                                                      child: Text(
                                                    e,
                                                    style: uiHelpers.title,
                                                  )),
                                                  onTap: () => model.changeIndex(
                                                      model.menuItems
                                                          .indexOf(e),
                                                      isMobile: true,
                                                      slideController:
                                                          menuAnimationController,
                                                      controller:
                                                          iconController),
                                                ))
                                            .toList(),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Transform.rotate(
                                          angle: -pi / 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 120, left: 60),
                                            child: FlickerTextAnimation(
                                              text: 'Menu',
                                              controller: menuTextController,
                                              textStyle: uiHelpers.headline!
                                                  .copyWith(fontSize: 50),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ])),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
