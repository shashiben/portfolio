import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:flutter_next/utils/shadows/next_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/app/constants/strings.dart';
import 'package:portfolio/widgets/custom_text.widget.dart';
import 'package:portfolio/widgets/omnitrix.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextContainer(children: [
      NextRow(
        crossAxisAlignment: WrapCrossAlignment.center,
        horizontalAlignment: WrapAlignment.center,
        verticalAlignment: WrapAlignment.center,
        children: [
          NextCol(
            sizes: 'col-12 col-md-6',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hey!👋 ',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomText(
                  text: "This is [b'Shashi]",
                  textMap: {
                    "b": GoogleFonts.breeSerif(
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [Color(0xFF00dd9b), Color(0xFF905bec)],
                          ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 30, 30))),
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  StringConstants.shortDesc,
                  style: TextStyle(
                    height: 1.5,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: NextShadow.shadow400(
                      color: Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Contact Me"),
                    ),
                  ),
                )
              ],
            ),
          ),
          const NextCol(
            sizes: 'col-12 col-md-6',
            child: OmnitrixWidget(),
          ),
        ],
      ),
    ]);
  }
}
