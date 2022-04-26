import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';

import '../../../app/key_configs.dart';

class ExperienceView extends StatelessWidget {
  const ExperienceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextContainer(
      fluid: true,
      padding: const EdgeInsets.symmetric(vertical: 60),
      key: KeyConfigs.experienceKey,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [Text("Experience")],
    );
  }
}
