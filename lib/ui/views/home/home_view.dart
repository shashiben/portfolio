import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/utils/architecture_view.dart';
import 'home_view_desktop.dart';
import 'home_view_mobile.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<HomeViewModel>(
        viewModel: HomeViewModel(),
        onModelReady: (model) => model.init(context),
        builder: (context, uiHelpers, model) {
          return Scaffold(
            body: ScreenTypeLayout(
                tablet: HomeDesktopView(model: model, uiHelpers: uiHelpers),
                mobile: HomeMobileView(model: model, uiHelpers: uiHelpers),
                desktop: HomeDesktopView(model: model, uiHelpers: uiHelpers)),
          );
        });
  }
}
