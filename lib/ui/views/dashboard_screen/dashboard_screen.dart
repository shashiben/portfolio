import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/app_bar.dart';

part 'dashboard_screen.viewmodel.dart';

class DashboardScreen extends StackedView<DashboardScreenViewModel> {
  const DashboardScreen({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget builder(
    BuildContext context,
    DashboardScreenViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppBarWidget(),
          Expanded(
            child: navigationShell,
          ),
        ],
      ),
    );
  }

  @override
  DashboardScreenViewModel viewModelBuilder(BuildContext context) =>
      DashboardScreenViewModel();
}
