import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/architecture_view.dart';
import 'package:portfolio/ui/views/main/main_view_model.dart';
import 'package:portfolio/ui/widgets/icon_switch.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final iconController =
        useAnimationController(duration: Duration(milliseconds: 700));
    return ScreenBuilder<MainViewModel>(
        onModelReady: (m) => m.init(),
        viewModel: MainViewModel(),
        builder: (context, uiHelpers, model) => Scaffold(
              body: ScreenTypeLayout(
                desktop: CollapsibleSidebar(
                    selectedIconColor: primaryColor,
                    maxWidth: 250,
                    avatarImg: AssetImage("assets/images/avatar.png"),
                    topPadding: 50,
                    body: model.child,
                    title: "Shashi Kumar",
                    items: model.collapsibleItem),
                tablet: CollapsibleSidebar(
                    maxWidth: 250,
                    avatarImg: AssetImage("assets/images/avatar.png"),
                    topPadding: 50,
                    body: model.child,
                    title: "Shashi Kumar",
                    items: model.collapsibleItem),
                mobile: Row(
                  children: <Widget>[
                    Container(
                      width: uiHelpers.width * 0.14,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 20),
                            child: IconButton(
                              icon: AnimatedIcon(
                                icon: AnimatedIcons.menu_close,
                                progress: iconController,
                              ),
                              onPressed: () =>
                                  model.changeMenuForMobile(iconController),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimateIcons(
                              startIcon: NeumorphicTheme.of(context).isUsingDark
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
                          )
                        ],
                      ),
                    ),
                    VerticalDivider(thickness: 1, width: 1),
                    Expanded(
                      child: PageView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          allowImplicitScrolling: false,
                          onPageChanged: (index) => model.changeIndex(index),
                          scrollDirection: Axis.vertical,
                          controller: model.pageController,
                          itemBuilder: (context, index) =>
                              model.views[model.index]),
                    )
                  ],
                ),
              ),
            ));
  }
}
