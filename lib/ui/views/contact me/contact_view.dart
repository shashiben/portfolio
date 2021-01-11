import 'package:flutter/material.dart';
import 'package:portfolio/core/utils/architecture_view.dart';

import 'contact_view_model.dart';

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<ContactViewModel>(
      viewModel: ContactViewModel(),
      onModelReady: (m) => m.init(),
      builder: (context, uiHelpers, model) => Scaffold(
        body: Form(
          key: model.formKey,
          child: Container(
            width: uiHelpers.width,
            height: uiHelpers.height,
            child: Container(
              padding: const EdgeInsets.only(left: 40).copyWith(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact Me",
                    style: uiHelpers.headline,
                  ),
                  uiHelpers.verticalSpaceMedium,
                  TextFormField()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
