import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:portfolio/app/key_configs.dart';
import 'package:portfolio/app/user_configs.dart';
import 'package:portfolio/modules/home%20module/widgets/skill_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextContainer(
      padding: const EdgeInsets.symmetric(vertical: 60),
      key: KeyConfigs.homeKey,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NextRow(
          children: [
            NextCol(
              sizes: "col-12 col-xl-6 col-lg-6 col-md-6 col-sm-12",
              child: Column(
                children: [
                  const Text(
                    "Hey,",
                    style: TextStyle(fontSize: 26, color: Colors.black54),
                  ),
                  const Text(
                    "This is Shashi Kumar",
                    style: TextStyle(fontSize: 32),
                  ),
                  Row(
                    children: [
                      NextButton(
                        onPressed: () {},
                        child: const Text("Contact Me"),
                      ),
                      NextButton(
                        onPressed: () {},
                        variant: NextButtonVariant.outlined,
                        child: const Text("Resume"),
                      )
                    ],
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            NextCol(
              sizes: "col-12 col-xl-6 col-lg-6 col-md-6 col-sm-12",
              child: Container(),
            )
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Container(
            width: context.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              NextRow(
                  children: UserConfigs.skillList
                      .map((e) => NextCol(
                          sizes:
                              "col-6 col-lg-3 col-xl-3 col-md-6 col-sm-6 col-xs-12",
                          child: SkillWidget(skill: e)))
                      .toList())
            ]),
            decoration: const BoxDecoration(
                color: Color(0xFF212234), borderRadius: BorderRadius.only()))
      ],
    ).center();
  }
}
