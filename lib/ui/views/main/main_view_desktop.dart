import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUtils.dart';
import 'package:portfolio/ui/views/main/main_view_model.dart';

class MainViewDesktop extends StatelessWidget {
  final MainViewModel model;
  final UIHelpers uiHelpers;
  final TabController tabController;
  final PageController pageController;

  const MainViewDesktop(
      {Key key,
      @required this.model,
      @required this.uiHelpers,
      @required this.tabController,
      @required this.pageController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: uiHelpers.width,
      height: uiHelpers.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(),
              Expanded(
                child: TabBar(
                  controller: tabController,
                  onTap: (int index) =>
                      model.changeIndex(index, tabController, pageController),
                  physics: BouncingScrollPhysics(),
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textPrimary),
                  unselectedLabelStyle: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: textPrimary),
                  labelColor: textPrimary,
                  unselectedLabelColor: textSecondary,
                  indicatorPadding: const EdgeInsets.only(right: 30, left: 20),
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "Home",
                    ),
                    Tab(
                      text: "About",
                    ),
                    Tab(
                      text: "Projects",
                    ),
                    Tab(
                      text: "Blog",
                    ),
                    Tab(
                      text: "Contact",
                    )
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              onPageChanged: (int index) {
                model.changePageState(index, tabController);
              },
              controller: pageController,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return model.views.values.elementAt(index);
              },
              itemCount: 5,
            ),
          )
        ],
      ),
    );
  }
}
