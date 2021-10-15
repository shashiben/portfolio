import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/utils/architecture_view.dart';
import 'contact_desktop_view.dart';
import 'contact_mobile_view.dart';
import 'contact_view_model.dart';

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<ContactViewModel>(
        viewModel: ContactViewModel(),
        onModelReady: (m) => m.init(),
        builder: (context, uiHelpers, model) => OKToast(
              radius: 5,
              textStyle: uiHelpers.body,
              child: ScreenTypeLayout(
                mobile: ContactMobileView(
                  uiHelpers: uiHelpers,
                  model: model,
                ),
                desktop: ContactDesktopView(
                  uiHelpers: uiHelpers,
                  model: model,
                ),
                tablet: ContactDesktopView(
                  uiHelpers: uiHelpers,
                  model: model,
                ),
              ),
            ));
  }
}
