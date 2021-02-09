import 'package:flutter/material.dart';
import 'package:portfolio/core/utils/architecture_view.dart';
import 'package:portfolio/ui/views/contact%20me/contact_desktop_view.dart';
import 'package:portfolio/ui/views/contact%20me/contact_mobile_view.dart';
import 'package:portfolio/ui/views/contact%20me/contact_tablet_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'contact_view_model.dart';

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<ContactViewModel>(
        viewModel: ContactViewModel(),
        onModelReady: (m) => m.init(),
        builder: (context, uiHelpers, model) => ScreenTypeLayout(
              mobile: ContactMobileView(
                uiHelpers: uiHelpers,
                model: model,
              ),
              desktop: ContactDesktopView(
                uiHelpers: uiHelpers,
                model: model,
              ),
              tablet: ContactTabletView(
                uiHelpers: uiHelpers,
                model: model,
              ),
            ));
  }
}
