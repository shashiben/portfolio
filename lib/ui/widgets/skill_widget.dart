import 'dart:math';

import 'package:flutter/material.dart';

class SkillLevel extends StatelessWidget {
  SkillLevel({
    @required this.skillLevel,
    @required this.skillName,
    this.width,
    this.circleWidth = 50,
    this.circleHeight = 50,
    this.textStyle,
    this.skillNameTextStyle,
    this.duration = const Duration(milliseconds: 500),
  });

  final double skillLevel;
  final String skillName;
  final double width;
  final double circleWidth;
  final double circleHeight;
  final TextStyle textStyle;
  final TextStyle skillNameTextStyle;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    var actualSkillLevel = skillLevel / 10;
    ThemeData theme = Theme.of(context);
    return Container(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: skillLevel),
            duration: duration,
            child: Container(
              width: circleWidth,
              height: circleHeight,
              child: Center(
                child: Text(
                  actualSkillLevel.toString(),
                  style: textStyle ??
                      theme.textTheme.subtitle1.copyWith(
                        color: Color(0xFF000000),
                      ),
                ),
              ),
            ),
            builder: (
              BuildContext context,
              double value,
              Widget child,
            ) {
              return CustomPaint(
                foregroundPainter: SkillProgressPainter(
                  currentProgress: value,
                  circleColor: Color(0xFFC7C9CA),
                  progressArcColor: Color(0xFF0E1319),
                ),
                child: AnimatedOpacity(
                  opacity: value / 100,
                  duration: duration,
                  child: child,
                ),
              );
            },
          ),
          Expanded(
            child: Text(
              skillName,
              style: skillNameTextStyle ??
                  theme.textTheme.subtitle1.copyWith(color: Color(0xFF000000)),
            ),
          ),
        ],
      ),
    );
  }
}

class SkillProgressPainter extends CustomPainter {
  SkillProgressPainter({
    @required this.currentProgress,
    this.circleStrokeWidth = 5,
    this.progressArcStrokeWidth = 5,
    this.circleColor = const Color(0xFFB5B8BC),
    this.progressArcColor = const Color(0xFF303E48),
  });

  final double currentProgress;
  final double circleStrokeWidth;
  final Color circleColor;
  final double progressArcStrokeWidth;
  final Color progressArcColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint innerCircle = Paint()
      ..strokeWidth = circleStrokeWidth
      ..color = circleColor
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = progressArcStrokeWidth
      ..color = progressArcColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 10;

    canvas.drawCircle(center, radius, innerCircle);

    double angle = 2 * pi * (currentProgress / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
