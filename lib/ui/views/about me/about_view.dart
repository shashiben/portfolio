import 'package:flutter/material.dart';
import '../../../core/utils/architecture_view.dart';
import 'about_view_all_size.dart';

import 'about_view_model.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<AboutViewModel>(
      viewModel: AboutViewModel(),
      onModelReady: (m) => m.init(),
      builder: (context, uiHelpers, model) => AboutViewResponsive(
        uiHelpers: uiHelpers,
        model: model,
      ),
    );
  }
}
