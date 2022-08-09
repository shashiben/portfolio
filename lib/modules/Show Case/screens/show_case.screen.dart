import 'package:flutter/material.dart';
import 'package:portfolio/modules/Show%20Case/components/app_dev.intro.component.dart';

class ShowCaseScreen extends StatelessWidget {
  const ShowCaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [AppDevIntroComponent()],
      ),
    );
  }
}
