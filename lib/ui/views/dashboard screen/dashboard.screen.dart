import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/widgets/app_bar.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class DashboardScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const DashboardScreen({Key? key, required this.navigationShell})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DynMouseScroll(builder: (context, controller, physics) {
      return Column(
        children: [
          MyAppBar(),
          Expanded(
            child: navigationShell,
          ),
        ],
      );
    }));
  }
}
