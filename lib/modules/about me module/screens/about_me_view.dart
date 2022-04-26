import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:portfolio/common%20widgets/mobile_shape.dart';

import '../../../app/key_configs.dart';

class AboutMeView extends StatelessWidget {
  const AboutMeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextContainer(
      fluid: true,
      padding: const EdgeInsets.symmetric(vertical: 60),
      key: KeyConfigs.aboutKey,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [Text("AboutMe"), MobilePhone()],
    );
  }
}
