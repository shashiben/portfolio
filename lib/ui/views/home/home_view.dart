import 'package:flutter/material.dart';
import 'package:portfolio/core/utils/architecture_view.dart';

import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<HomeViewModel>(
      viewModel: HomeViewModel(),
      onModelReady: (m) => m.init(),
      builder: (context, uiHelpers, model) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Text(
            "Hi",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
