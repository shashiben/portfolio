import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/architecture_view.dart';
import 'package:portfolio/ui/views/main/main_view_model.dart';
import 'package:portfolio/ui/widgets/icon_switch.dart';
import 'package:portfolio/ui/widgets/icon_wrapper.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final iconController =
        useAnimationController(duration: Duration(milliseconds: 700));
    final menuAnimationController =
        useAnimationController(duration: Duration(milliseconds: 700));
    final offset = Tween(end: Offset.zero, begin: Offset(1, 0))
        .animate(menuAnimationController);

    return ScreenBuilder<MainViewModel>(
        onModelReady: (m) => m.init(),
        viewModel: MainViewModel(),
        builder: (context, uiHelpers, model) => Scaffold(
              backgroundColor: uiHelpers.backgroundColor,
              floatingActionButton: model.isMobile(context)
                  ? SizedBox()
                  : FloatingActionButton(
                      backgroundColor: uiHelpers.primaryColor,
                      onPressed: () {},
                      child: AnimateIcons(
                        startIcon: NeumorphicTheme.of(context).isUsingDark
                            ? MenuIcons.sunIcon
                            : MenuIcons.moonIcon,
                        size: 30.0,
                        controller: AnimateIconController(),
                        startTooltip: NeumorphicTheme.of(context).isUsingDark
                            ? 'Dark Mode'
                            : "Light Mode",
                        endTooltip: !NeumorphicTheme.of(context).isUsingDark
                            ? 'Dark Mode'
                            : "Light Mode",
                        onStartIconPress: () {
                          NeumorphicTheme.of(context).themeMode =
                              NeumorphicTheme.of(context).isUsingDark
                                  ? ThemeMode.light
                                  : ThemeMode.dark;
                          return true;
                        },
                        onEndIconPress: () {
                          print(NeumorphicTheme.of(context).isUsingDark);
                          NeumorphicTheme.of(context).themeMode =
                              ThemeMode.dark;

                          return true;
                        },
                        duration: Duration(milliseconds: 500),
                        startIconColor: Colors.deepPurple,
                        endIconColor: Colors.deepOrange,
                        clockwise: false,
                      ),
                    ),
              body: ScreenTypeLayout(
                desktop: CollapsibleSidebar(
                    fitItemsToBottom: false,
                    selectedIconColor: primaryColor,
                    maxWidth: 250,
                    avatarImg: AssetImage("assets/images/s.jpg"),
                    topPadding: 50,
                    body: model.child,
                    title: "Shashi Kumar",
                    items: model.collapsibleItem),
                tablet: CollapsibleSidebar(
                    maxWidth: 250,
                    avatarImg: AssetImage("assets/images/s.jpg"),
                    topPadding: 50,
                    body: model.child,
                    title: "Shashi Kumar",
                    items: model.collapsibleItem),
                mobile: Container(
                  width: uiHelpers.width,
                  height: uiHelpers.height,
                  child: Stack(
                    children: [
                      Row(
                        children: <Widget>[
                          Container(
                            color: uiHelpers.surfaceColor,
                            width: uiHelpers.width * 0.14,
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
                                        menuAnimationController),
                                  ),
                                ),
                                Spacer(),
                                IconWrrapper(
                                    padding: const EdgeInsets.all(4),
                                    onTap: () {},
                                    child: Center(
                                        child:
                                            Icon(ContactIcons.facebookIcon))),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AnimateIcons(
                                    startIcon:
                                        NeumorphicTheme.of(context).isUsingDark
                                            ? MenuIcons.sunIcon
                                            : MenuIcons.moonIcon,
                                    size: 30.0,
                                    controller: AnimateIconController(),
                                    startTooltip:
                                        NeumorphicTheme.of(context).isUsingDark
                                            ? 'Dark Mode'
                                            : "Light Mode",
                                    endTooltip:
                                        !NeumorphicTheme.of(context).isUsingDark
                                            ? 'Dark Mode'
                                            : "Light Mode",
                                    onStartIconPress: () {
                                      NeumorphicTheme.of(context).themeMode =
                                          NeumorphicTheme.of(context)
                                                  .isUsingDark
                                              ? ThemeMode.light
                                              : ThemeMode.dark;
                                      return true;
                                    },
                                    onEndIconPress: () {
                                      print(NeumorphicTheme.of(context)
                                          .isUsingDark);
                                      NeumorphicTheme.of(context).themeMode =
                                          ThemeMode.dark;

                                      return true;
                                    },
                                    duration: Duration(milliseconds: 500),
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
                                physics: NeverScrollableScrollPhysics(),
                                allowImplicitScrolling: false,
                                onPageChanged: (index) =>
                                    model.changeIndex(index),
                                scrollDirection: Axis.vertical,
                                controller: model.pageController,
                                itemBuilder: (context, index) =>
                                    model.views[model.index]),
                          )
                        ],
                      ),
                      Container(
                        height: uiHelpers.height,
                        width: uiHelpers.width,
                        child: SlideTransition(
                            position: offset,
                            child: Row(children: [
                              Container(width: uiHelpers.width * 0.14),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: uiHelpers.surfaceColor),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: model.menuItems
                                        .map((e) => ListTile(
                                              title: Center(
                                                  child: Text(
                                                e,
                                                style: uiHelpers.title,
                                              )),
                                              onTap: () => model.changeIndex(
                                                  model.menuItems.indexOf(e),
                                                  isMobile: true,
                                                  slideController:
                                                      menuAnimationController,
                                                  controller: iconController),
                                            ))
                                        .toList(),
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
