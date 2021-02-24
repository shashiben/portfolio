import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:portfolio/core/utils/architecture_view.dart';
import 'package:portfolio/ui/views/main/main_view_model.dart';

class MainView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<MainViewModel>(
      onModelReady: (m) => m.init(),
      viewModel: MainViewModel(),
      builder: (context, uiHelpers, model) => Scaffold(
        body: CollapsibleSidebar(
            topPadding: 50,
            body: model.child,
            title: "Shashi Kumar",
            items: model.collapsibleItem),
      ),
    );
  }
}
