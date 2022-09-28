import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:portfolio/app/constants/data/skill.data.dart';
import 'package:portfolio/widgets/painters/triangle.painter.dart';

class OmnitrixWidget extends StatefulWidget {
  const OmnitrixWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<OmnitrixWidget> createState() => _OmnitrixWidgetState();
}

class _OmnitrixWidgetState extends State<OmnitrixWidget>
    with TickerProviderStateMixin {
  late AnimationController scaleController;
  late AnimationController fadeController;
  int index = 0;
  final PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 800),
    );
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(),
      reverseDuration: const Duration(milliseconds: 1500),
    );
    pageController.addListener(() {
      int newIndex = pageController.page?.round() ?? 0;
      if (newIndex != index) {
        setState(() {
          index = newIndex;
        });
        scaleController.forward().then((value) => scaleController.reverse());
        fadeController.forward().then((value) => fadeController.reverse());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scaleController.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double radius = 300;
    double smallRadius = 24;
    return SizedBox(
        height: context.height * 0.8 -
            (context.themeData.appBarTheme.toolbarHeight ?? 0),
        child: Center(
          child: SizedBox(
            height: radius,
            width: radius,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(smallRadius),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF363636),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(120),
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.green,
                                  child: PageView.builder(
                                    itemCount: skillList.length,
                                    controller: pageController,
                                    scrollBehavior: AppScrollBehavior(),
                                    itemBuilder: (context, index) => ClipPath(
                                      child: FadeTransition(
                                        opacity: Tween(begin: 1.0, end: 0.0)
                                            .animate(fadeController),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: skillList[index].color),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  skillList[index].image,
                                                  height: 100,
                                                  width: 100,
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  skillList[index].title,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                    // options: CarouselOptions(
                                    //   autoPlay: true,
                                    // ),
                                  ),
                                ),
                                Positioned(
                                    child: SizedBox(
                                  width: 198,
                                  height: 198,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ScaleTransition(
                                          alignment: Alignment.centerLeft,
                                          scale: Tween(begin: 0.0, end: 1.0)
                                              .animate(scaleController),
                                          child: ClipPath(
                                            clipper: TriangleClipperr(),
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.black),
                                                child: const Center()),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ScaleTransition(
                                          alignment: Alignment.centerRight,
                                          scale: Tween(begin: 0.0, end: 1.0)
                                              .animate(scaleController),
                                          child: ClipPath(
                                            clipper: TriangleClipperr(
                                                type: TriangleType.right),
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.black),
                                                child: const Center()),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                                Positioned(
                                    child: SizedBox(
                                  width: 198,
                                  height: 198,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ScaleTransition(
                                          alignment: Alignment.topCenter,
                                          scale: Tween(begin: 0.0, end: 1.0)
                                              .animate(scaleController),
                                          child: ClipPath(
                                            clipper: TriangleClipperr(
                                                type: TriangleType.top),
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                child: const Center()),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ScaleTransition(
                                          alignment: Alignment.bottomCenter,
                                          scale: Tween(begin: 0.0, end: 1.0)
                                              .animate(scaleController),
                                          child: ClipPath(
                                            clipper: TriangleClipperr(
                                                type: TriangleType.bottom),
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                child: const Center()),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    left: (radius - (smallRadius)) / 2,
                    child: smallCircle(
                      smallRadius,
                    )),
                Positioned(
                    left: 0,
                    top: (radius - (smallRadius)) / 2,
                    child: smallCircle(
                      smallRadius,
                    )),
                Positioned(
                    right: 0,
                    top: (radius - (smallRadius)) / 2,
                    child: smallCircle(
                      smallRadius,
                    ).onTap(() {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.linear);
                    })),
                Positioned(
                    bottom: 0,
                    left: (radius - (smallRadius)) / 2,
                    child: smallCircle(
                      smallRadius,
                    )),
              ],
            ),
          ),
        ));
  }

  Widget smallCircle(double smallRadius) {
    return Container(
      width: smallRadius,
      height: smallRadius,
      decoration: BoxDecoration(
          border: Border.all(),
          shape: BoxShape.circle,
          color: const Color(0xFF363636)),
      padding: const EdgeInsets.all(4),
      child: Container(
          decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      )),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      };
}
