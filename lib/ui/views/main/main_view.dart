import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/architecture_view.dart';
import 'package:portfolio/ui/views/main/main_view_model.dart';
import 'package:portfolio/ui/widgets/icon_wrapper.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainView extends HookWidget {
  @override
  Widget build(BuildContext context) {
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
              NavigationRail(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 20),
                  child: Icon(MenuIcons.menuIcon),
                ),
                selectedIconTheme: IconThemeData(color: primaryColor),
                unselectedIconTheme:
                    IconThemeData(color: primaryColor.withOpacity(0.4)),
                selectedIndex: model.index,
                onDestinationSelected: (int index) => model.changeIndex(index),
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(MenuIcons.homeIcon),
                    selectedIcon: IconWrapper(
                      child: Icon(
                        MenuIcons.homeIcon,
                      ),
                    ),
                    label: Text(''),
                  ),
                  NavigationRailDestination(
                    icon: Icon(MenuIcons.aboutIcon),
                    selectedIcon: IconWrapper(
                      child: Icon(
                        MenuIcons.aboutIcon,
                      ),
                    ),
                    label: Text(''),
                  ),
                  NavigationRailDestination(
                    icon: Icon(MenuIcons.projectIcon),
                    selectedIcon: IconWrapper(
                      child: Icon(
                        MenuIcons.projectIcon,
                      ),
                    ),
                    label: Text(''),
                  ),
                  NavigationRailDestination(
                    icon: Icon(MenuIcons.experienceIcon),
                    selectedIcon: IconWrapper(
                      child: Icon(
                        MenuIcons.experienceIcon,
                      ),
                    ),
                    label: Text(''),
                  ),
                  NavigationRailDestination(
                    icon: Icon(MenuIcons.contactIcon),
                    selectedIcon: IconWrapper(
                      child: Icon(
                        MenuIcons.contactIcon,
                      ),
                    ),
                    label: Text(''),
                  ),
                ],
              ),
              VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    allowImplicitScrolling: false,
                    onPageChanged: (index) => model.changeIndex(index),
                    scrollDirection: Axis.vertical,
                    controller: model.pageController,
                    itemBuilder: (context, index) => model.views[model.index]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
