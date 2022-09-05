import 'package:flutter/material.dart';
import 'package:portfolio/app/constants/colors.dart';
import 'package:portfolio/widgets/logo.dart';

import '../../../widgets/components/footer.dart';

class ShowCaseScreen extends StatelessWidget {
  const ShowCaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: ['Home', 'About me', "Projects", "Experience", 'Contact']
                .map((e) => TextButton(onPressed: () {}, child: Text(e)))
                .toList()),
        leadingWidth: 400,
        leading: const LogoComponent(),
      ),
      backgroundColor: ColorConfigs.backgroundColor,
      body: Column(
        children: const [FooterWidget()],
      ),
    );
  }
}
