import 'package:flutter/material.dart';
import 'package:portfolio/gen/assets.gen.dart';
import 'package:flutter_next/flutter_next.dart';

class LogoComponent extends StatelessWidget {
  const LogoComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Assets.images.s.image(),
        const SizedBox(
          width: 6,
        ),
        Text.rich(TextSpan(children: [
          const TextSpan(
              text: 'Shashi ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              )),
          TextSpan(
              text: 'Kumar',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: context.primaryColor,
                fontSize: 14,
              )),
        ]))
      ],
    );
  }
}
