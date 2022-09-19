import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            NextContainer(children: [
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  runSpacing: 12,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Copyright Ⓒ ${DateTime.now().year} Shashi. All Rights Reserved.',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.instagram,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.twitter,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.linkedin,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.github,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ],
        ));
  }
}
