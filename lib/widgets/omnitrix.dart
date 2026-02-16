// ignore_for_file: unnecessary_const

import 'package:dev_utils/screen_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app/constants/data/skill.data.dart';
import '../app/tokens/tokens.dart';
import 'painters/triangle.painter.dart';

bool _isNetworkUrl(String url) => url.startsWith('http://') || url.startsWith('https://');

class OmnitrixWidget extends StatefulWidget {
  final double? size;
  const OmnitrixWidget({
    super.key,
    this.size,
  });

  @override
  State<OmnitrixWidget> createState() => _OmnitrixWidgetState();
}

class _OmnitrixWidgetState extends State<OmnitrixWidget> with TickerProviderStateMixin {
  late AnimationController scaleController;
  late AnimationController fadeController;
  int index = 0;
  final PageController pageController = PageController();
  ValueNotifier<bool> isPageScrolling = ValueNotifier(false);

  late AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 800),
    )..addStatusListener((status) {
        setState(() {
          isPageScrolling.value = status == AnimationStatus.forward || status == AnimationStatus.reverse;
        });
      });
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    rotationController.addListener(() {
      setState(() {});
    });
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(),
      reverseDuration: const Duration(milliseconds: 1500),
    );

    pageController.addListener(() {
      final newIndex = pageController.page?.round() ?? 0;
      if (newIndex != index) {
        setState(() => index = newIndex);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runInitialAnimation();
    });
  }

  void _goToNext() {
    final next = ((pageController.page?.round() ?? 0) + 1) % skillList.length;
    pageController.jumpToPage(next);
  }

  void _goToPrevious() {
    final current = pageController.page?.round() ?? 0;
    final prev = current <= 0 ? skillList.length - 1 : current - 1;
    pageController.jumpToPage(prev);
  }

  Future<void> _runInitialAnimation() async {
    scaleController.forward().then((_) => scaleController.reverse());
    fadeController.forward().then((_) => fadeController.reverse());
    rotationController.forward(from: 0.0);

    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    scaleController.dispose();
    fadeController.dispose();
    rotationController.dispose();
    pageController.dispose();
    super.dispose();
  }

  static const _baseSize = 300.0;
  static const _minSize = 120.0;
  static const _maxSize = 400.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        double size = widget.size ?? _baseSize;
        if (widget.size == null && (maxW.isFinite || maxH.isFinite)) {
          final limit = maxW.isFinite && maxH.isFinite ? (maxW < maxH ? maxW : maxH) : (maxW.isFinite ? maxW : maxH);
          size = limit.isFinite ? limit.clamp(_minSize, _maxSize) : _baseSize;
        } else if (widget.size != null) {
          size = size.clamp(_minSize, _maxSize);
        }

        final radius = size;
        final scale = size / _baseSize;
        final smallRadius = SpacingTokens.omnitrixSmallRadius * scale;
        final innerSize = radius - 2 * smallRadius;

        return SizedBox(
          height: radius,
          child: Center(
            child: SizedBox(
              height: radius,
              width: radius,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  AnimatedRotation(
                    turns: index / 4,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: isPageScrolling,
                          builder: (context, bool isAnimating, child) => CustomPaint(
                            size: Size(radius, radius),
                            painter: _OuterRingPainter(
                              ringColor: const Color(0xFF363636),
                              innerRadius: innerSize / 2,
                              glow: isAnimating,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: (radius - smallRadius) / 2,
                          child: smallCircle(smallRadius),
                        ),
                        Positioned(
                          left: 0,
                          top: (radius - smallRadius) / 2,
                          child: smallCircle(smallRadius),
                        ),
                        Positioned(
                          right: 0,
                          top: (radius - smallRadius) / 2,
                          child: smallCircle(smallRadius).onTap(_goToNext),
                        ),
                        Positioned(
                          bottom: 0,
                          left: (radius - smallRadius) / 2,
                          child: smallCircle(smallRadius),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: innerSize,
                      height: innerSize,
                      child: Container(
                        padding: EdgeInsets.all(SpacingTokens.omnitrixInnerPadding * scale),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(SpacingTokens.omnitrixRingPadding * scale),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(SpacingTokens.omnitrixRingPadding * scale),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(SpacingTokens.omnitrixBorderRadius * scale),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: const Color(0xFF363636),
                                    ),
                                    child: ClipPath(
                                      clipper: DiamondClipper(),
                                      child: Container(
                                        color: Colors.black,
                                        child: GestureDetector(
                                          onHorizontalDragEnd: (details) {
                                            final v = details.primaryVelocity ?? 0;
                                            if (v < -100) {
                                              _goToNext();
                                            } else if (v > 100) {
                                              _goToPrevious();
                                            }
                                          },
                                          child: PageView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: skillList.length,
                                            controller: pageController,
                                            scrollBehavior: AppScrollBehavior(),
                                            itemBuilder: (context, index) => Container(
                                              color: Colors.grey,
                                              child: Container(
                                                color: Colors.black,
                                                padding: EdgeInsets.all(SpacingTokens.omnitrixContentPadding * scale),
                                                child: ClipPath(
                                                  clipper: DiamondClipper(),
                                                  child: FadeTransition(
                                                    opacity: Tween(begin: 1.0, end: 0.0).animate(fadeController),
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                        color: Colors.green,
                                                      ),
                                                      child: Center(
                                                        child: _isNetworkUrl(skillList[index].image)
                                                            ? SvgPicture.network(
                                                                skillList[index].image,
                                                                fit: BoxFit.contain,
                                                                height: 50,
                                                                width: 50,
                                                                placeholderBuilder: (_) => Icon(
                                                                  Icons.code,
                                                                  size: innerSize / 2,
                                                                  color: Colors.white70,
                                                                ),
                                                              )
                                                            : Image.asset(
                                                                skillList[index].image,
                                                                fit: BoxFit.contain,
                                                                height: innerSize / 2,
                                                                width: innerSize / 2,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: SizedBox(
                                      width: SpacingTokens.omnitrixOverlaySize * scale,
                                      height: SpacingTokens.omnitrixOverlaySize * scale,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ScaleTransition(
                                              alignment: Alignment.centerLeft,
                                              scale: Tween(begin: 0.0, end: 1.0).animate(scaleController),
                                              child: ClipPath(
                                                clipper: TriangleClipperr(),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.black,
                                                  ),
                                                  child: const Center(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ScaleTransition(
                                              alignment: Alignment.centerRight,
                                              scale: Tween(begin: 0.0, end: 1.0).animate(scaleController),
                                              child: ClipPath(
                                                clipper: TriangleClipperr(
                                                  type: TriangleType.right,
                                                ),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.black,
                                                  ),
                                                  child: const Center(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: SizedBox(
                                      width: SpacingTokens.omnitrixOverlaySize * scale,
                                      height: SpacingTokens.omnitrixOverlaySize * scale,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ScaleTransition(
                                              alignment: Alignment.topCenter,
                                              scale: Tween(begin: 0.0, end: 1.0).animate(scaleController),
                                              child: ClipPath(
                                                clipper: TriangleClipperr(
                                                  type: TriangleType.top,
                                                ),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: const Center(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ScaleTransition(
                                              alignment: Alignment.bottomCenter,
                                              scale: Tween(begin: 0.0, end: 1.0).animate(scaleController),
                                              child: ClipPath(
                                                clipper: TriangleClipperr(
                                                  type: TriangleType.bottom,
                                                ),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: const Center(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget smallCircle(double smallRadius) => ValueListenableBuilder(
        valueListenable: isPageScrolling,
        builder: (context, bool isAnimating, child) => AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: smallRadius,
          height: smallRadius,
          decoration: BoxDecoration(
            border: Border.all(),
            shape: BoxShape.circle,
            color: const Color(0xFF363636),
            boxShadow: isAnimating
                ? [
                    BoxShadow(
                      color: Colors.greenAccent.withValues(alpha: .5),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ]
                : null,
          ),
          padding: EdgeInsets.all(SpacingTokens.omnitrixRingPadding),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
        ),
      );
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

class _OuterRingPainter extends CustomPainter {
  _OuterRingPainter({
    required this.ringColor,
    required this.innerRadius,
    this.glow = false,
  });

  final Color ringColor;
  final double innerRadius;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;

    if (glow) {
      canvas.drawCircle(
        center,
        outerRadius,
        Paint()
          ..color = Colors.greenAccent.withValues(alpha: 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      );
    }

    final outerPath = Path()..addOval(Rect.fromCircle(center: center, radius: outerRadius));
    final innerPath = Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius));
    final ringPath = Path.combine(PathOperation.difference, outerPath, innerPath);

    canvas.drawPath(
      ringPath,
      Paint()
        ..color = ringColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      ringPath,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _OuterRingPainter oldDelegate) =>
      oldDelegate.ringColor != ringColor || oldDelegate.innerRadius != innerRadius || oldDelegate.glow != glow;
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width * 0.5, 0)
    ..lineTo(0, size.height * 0.5)
    ..lineTo(size.width * 0.5, size.height)
    ..lineTo(size.width, size.height * 0.5)
    ..lineTo(size.width * 0.5, 0)
    ..close();

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
