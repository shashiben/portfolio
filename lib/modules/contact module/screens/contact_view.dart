import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';

import '../../../app/key_configs.dart';

class ContactView extends StatelessWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextContainer(
      padding: const EdgeInsets.symmetric(vertical: 60),
      key: KeyConfigs.contactKey,
      children: [
        NextRow(
          children: [
            NextCol(
              child: Column(
                children: [
                  Text(
                    'Contact',
                    style: context.textThemeHeadline3,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              sizes: 'col-12 col-md-6 col-sm-12 col-xxl-6 col-xl-6 col-lg-6',
            ),
            NextCol(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              sizes: 'col-12 col-md-6 col-sm-12 col-xxl-6 col-xl-6 col-lg-6',
            )
          ],
        )
      ],
    );
  }
}
