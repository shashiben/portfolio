import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';

import '../../../app/key_configs.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextContainer(
      fluid: true,
      padding: const EdgeInsets.symmetric(vertical: 60),
      key: KeyConfigs.projectKey,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [Text("Projects")],
    );
  }
}
