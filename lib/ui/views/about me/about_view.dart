import 'package:flutter/material.dart';
import 'package:portfolio/core/utils/architecture_view.dart';
import 'package:portfolio/ui/views/about%20me/about_view_desktop.dart';
import 'package:portfolio/ui/views/about%20me/about_view_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'about_view_model.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<AboutViewModel>(
        viewModel: AboutViewModel(),
        onModelReady: (m) => m.init(),
        builder: (context, uiHelpers, model) => ScreenTypeLayout(
              mobile: AboutMobileView(
                uiHelpers: uiHelpers,
                model: model,
              ),
              tablet: AboutDesktopView(
                uiHelpers: uiHelpers,
                model: model,
              ),
              desktop: AboutDesktopView(
                uiHelpers: uiHelpers,
                model: model,
              ),
            ));
  }
}
