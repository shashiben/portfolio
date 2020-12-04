import 'package:flutter/material.dart';

import 'package:portfolio/core/utils/architecture_view.dart';
import 'package:portfolio/ui/views/main/main_view_desktop.dart';
import 'package:portfolio/ui/views/main/main_view_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'main_view_model.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _tabController = TabController(initialIndex: 0, vsync: this, length: 5);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<MainViewModel>(
      viewModel: MainViewModel(),
      onModelReady: (m) => m.init(context),
      builder: (context, uiHelpers, model) => Scaffold(
          body: ScreenTypeLayout(
        desktop: MainViewDesktop(
          uiHelpers: uiHelpers,
          model: model,
          tabController: _tabController,
          pageController: _pageController,
        ),
        mobile: MainViewMobile(
          uiHelpers: uiHelpers,
          model: model,
          tabController: _tabController,
          pageController: _pageController,
        ),
      )),
    );
  }
}
