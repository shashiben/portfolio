import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/app/constants/colors.dart';
import 'package:portfolio/gen/assets.gen.dart';
import 'package:portfolio/modules/Home%20Page/screens/home.screen.dart';
import 'package:portfolio/widgets/logo.dart';
import 'package:flutter_next/flutter_next.dart';
import '../../../widgets/components/footer.dart';

class ShowCaseScreen extends StatelessWidget {
  const ShowCaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.width < 600
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(Assets.icons.menu,
                        color: ColorConfigs.iconColor),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  'Home',
                  'About me',
                  "Projects",
                  "Experience",
                  'Contact'
                ]
                    .map((e) => TextButton(onPressed: () {}, child: Text(e)))
                    .toList()),
        leadingWidth: 400,
        leading: const LogoComponent(),
      ),
      backgroundColor: ColorConfigs.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: const [HomeScreen(), FooterWidget()],
        ),
      ),
    );
  }
}
