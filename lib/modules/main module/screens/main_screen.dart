import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/modules/about%20me%20module/screens/about_me_view.dart';
import 'package:portfolio/modules/contact%20module/screens/contact_view.dart';
import 'package:portfolio/modules/experience%20module/screens/experience_view.dart';
import 'package:portfolio/modules/footer%20module/views/footer_view.dart';
import 'package:portfolio/modules/home%20module/screens/home_view.dart';
import 'package:portfolio/modules/projects%20module/screens/projects_view.dart';

class MainScreen extends StatelessWidget {
  final String title;
  const MainScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF212234),
          ),
          child: NextContainer(
            decoration: const BoxDecoration(
              color: Color(0xFF212234),
            ),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/s.png",
                    height: 50,
                    width: 50,
                  ),
                  Expanded(
                    child: Row(
                      children: ["Home", "Projects", "Experience", "Contacts"]
                          .map((e) {
                        String text = e;
                        TextStyle textStyle =
                            const TextStyle(fontSize: 16, color: Colors.white);
                        return HoverWidget(builder: (context, isHovered) {
                          return TextButton(
                              onPressed: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    text,
                                    style: textStyle,
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    height: 3,
                                    width: isHovered
                                        ? _textSize(text, textStyle).width
                                        : 0,
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                  ).customPadding(top: 5)
                                ],
                              ).paddingSymmetric(horizontal: 15, vertical: 0));
                        });
                      }).toList(),
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.comment,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ).center(),
        ),
        preferredSize: const Size.fromHeight(75),
      ),
      body: SingleChildScrollView(
        child: Column(children: const [
          HomeView(),
          AboutMeView(),
          ProjectsView(),
          ExperienceView(),
          ContactView(),
          FooterView()
        ]),
      ),
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout();
    return textPainter.size;
  }
}
