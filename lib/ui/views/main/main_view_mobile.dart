import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUtils.dart';
import 'package:portfolio/ui/views/main/main_view_model.dart';

class MainViewMobile extends StatefulWidget {
  final MainViewModel model;
  final UIHelpers uiHelpers;
  final TabController tabController;
  final PageController pageController;

  const MainViewMobile(
      {Key key,
      @required this.model,
      @required this.uiHelpers,
      @required this.tabController,
      @required this.pageController})
      : super(key: key);

  @override
  _MainViewMobileState createState() => _MainViewMobileState();
}

class _MainViewMobileState extends State<MainViewMobile> {
  int index = 0;
  changeIndex(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.uiHelpers.width,
      height: widget.uiHelpers.height,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: widget.uiHelpers.width * 0.15,
            child: NavigationRail(
              elevation: 2.0,
              onDestinationSelected: (int index) {
                changeIndex(index);

                widget.model.changeIndex(
                    index, widget.tabController, widget.pageController);
              },
              leading: Container(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Icon(FlutterIcons.grid_fea)),
              selectedIndex: index,
              backgroundColor: Colors.black,
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                    icon: RotatedBox(
                      quarterTurns: 1,
                      child: Text("Home",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: textSecondary)),
                    ),
                    label: Text(""),
                    selectedIcon: RotatedBox(
                      quarterTurns: 1,
                      child: Text("Home",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textPrimary)),
                    )),
                NavigationRailDestination(
                    icon: RotatedBox(
                      quarterTurns: 1,
                      child: Text("About",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: textSecondary)),
                    ),
                    label: Text(""),
                    selectedIcon: RotatedBox(
                      quarterTurns: 1,
                      child: Text("About",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textPrimary)),
                    )),
                NavigationRailDestination(
                    icon: RotatedBox(
                      quarterTurns: 1,
                      child: Text("Projects",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: textSecondary)),
                    ),
                    label: Text(""),
                    selectedIcon: RotatedBox(
                      quarterTurns: 1,
                      child: Text("Projects",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textPrimary)),
                    )),
                NavigationRailDestination(
                    icon: RotatedBox(
                      quarterTurns: 1,
                      child: Text("Blog",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: textSecondary)),
                    ),
                    label: Text(""),
                    selectedIcon: RotatedBox(
                      quarterTurns: 1,
                      child: Text("Blog",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textPrimary)),
                    )),
                NavigationRailDestination(
                    icon: RotatedBox(
                      quarterTurns: 1,
                      child: Text("Contact",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: textSecondary)),
                    ),
                    label: Text(""),
                    selectedIcon: RotatedBox(
                      quarterTurns: 1,
                      child: Text("Contact",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textPrimary)),
                    )),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: Colors.white24,
          ),
          Expanded(
            child: PageView.builder(
              onPageChanged: (int index) {
                widget.model.changePageState(index, widget.tabController);
                changeIndex(index);
              },
              controller: widget.pageController,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return widget.model.views.values.elementAt(index);
              },
              itemCount: 5,
            ),
          )
        ],
      ),
    );
  }
}
