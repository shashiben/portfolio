import 'dart:math';

import 'package:dev_utils/extensions/context_extensions.dart';
import 'package:dev_utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/gen/assets.gen.dart';

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(context.width, kToolbarHeight),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: max(20, context.width * 0.02)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "SK",
              style: context.textTheme.displayMedium,
            ),
            Expanded(child: LayoutBuilder(builder: (context, constraints) {
              return (constraints.maxWidth > 620)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ...[
                          "home",
                          "about-me",
                          "experience",
                          "projects",
                          "certificates",
                          "contact-me"
                        ].map((title) => TextButton(
                            onPressed: () {
                              context.go("/$title");
                            },
                            child:
                                Text(title.capitalize().replaceAll("-", " ")))),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "Resume",
                          ),
                        )
                      ],
                    )
                  : Row(
                      children: [
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(Assets.icons.menu),
                        ),
                      ],
                    );
            }))
          ],
        ),
      ),
    );
  }
}
