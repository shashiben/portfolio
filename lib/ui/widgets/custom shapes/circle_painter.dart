import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../percent_indicator.dart';

class CirclePainter extends CustomPainter {
  final Paint _paintBackground = Paint();
  final Paint _paintLine = Paint();
  final Paint _paintBackgroundStartAngle = Paint();
  final double lineWidth;
  final double backgroundWidth;
  final double? progress;
  final double radius;
  final Color progressColor;
  final Color backgroundColor;
  final CircularStrokeCap? circularStrokeCap;
  final double startAngle;
  final LinearGradient? linearGradient;
  final Color? arcBackgroundColor;
  final ArcType? arcType;
  final bool? reverse;
  final MaskFilter? maskFilter;
  final bool? rotateLinearGradient;

  CirclePainter(
      {required this.lineWidth,
      required this.backgroundWidth,
      this.progress,
      required this.radius,
      required this.progressColor,
      required this.backgroundColor,
      this.startAngle = 0.0,
      this.circularStrokeCap = CircularStrokeCap.round,
      this.linearGradient,
      this.reverse,
      this.arcBackgroundColor,
      this.arcType,
      this.maskFilter,
      this.rotateLinearGradient}) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeWidth = backgroundWidth;

    if (arcBackgroundColor != null) {
      _paintBackgroundStartAngle.color = arcBackgroundColor!;
      _paintBackgroundStartAngle.style = PaintingStyle.stroke;
      _paintBackgroundStartAngle.strokeWidth = lineWidth;
      if (circularStrokeCap == CircularStrokeCap.round) {
        _paintBackgroundStartAngle.strokeCap = StrokeCap.round;
      } else if (circularStrokeCap == CircularStrokeCap.butt) {
        _paintBackgroundStartAngle.strokeCap = StrokeCap.butt;
      } else {
        _paintBackgroundStartAngle.strokeCap = StrokeCap.square;
      }
    }

    _paintLine.color = progressColor;
    _paintLine.style = PaintingStyle.stroke;
    _paintLine.strokeWidth = lineWidth;
    if (circularStrokeCap == CircularStrokeCap.round) {
      _paintLine.strokeCap = StrokeCap.round;
    } else if (circularStrokeCap == CircularStrokeCap.butt) {
      _paintLine.strokeCap = StrokeCap.butt;
    } else {
      _paintLine.strokeCap = StrokeCap.square;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, _paintBackground);

    if (maskFilter != null) {
      _paintLine.maskFilter = maskFilter;
    }
    if (linearGradient != null) {
      if (rotateLinearGradient! && progress! > 0) {
        double correction = 0;
        if (_paintLine.strokeCap == StrokeCap.round ||
            _paintLine.strokeCap == StrokeCap.square) {
          if (reverse!) {
            correction = math.atan(_paintLine.strokeWidth / 2 / radius);
          } else {
            correction = math.atan(_paintLine.strokeWidth / 2 / radius);
          }
        }
        _paintLine.shader = SweepGradient(
                transform: reverse!
                    ? GradientRotation(
                        radians(-90 - progress! + startAngle) - correction)
                    : GradientRotation(
                        radians(-90.0 + startAngle) - correction),
                startAngle: radians(0) as double,
                endAngle: radians(progress!) as double,
                colors: reverse!
                    ? linearGradient!.colors.reversed.toList()
                    : linearGradient!.colors)
            .createShader(
          Rect.fromCircle(
            center: center,
            radius: radius,
          ),
        );
      } else if (!rotateLinearGradient!) {
        _paintLine.shader = linearGradient!.createShader(
          Rect.fromCircle(
            center: center,
            radius: radius,
          ),
        );
      }
    }

    double fixedStartAngle = startAngle;

    double startAngleFixedMargin = 1.0;
    if (arcType != null) {
      if (arcType == ArcType.full) {
        fixedStartAngle = 220;
        startAngleFixedMargin = 172 / fixedStartAngle;
      } else {
        fixedStartAngle = 270;
        startAngleFixedMargin = 135 / fixedStartAngle;
      }
    }

    if (arcBackgroundColor != null) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        radians(-90.0 + fixedStartAngle) as double,
        radians(360 * startAngleFixedMargin) as double,
        false,
        _paintBackgroundStartAngle,
      );
    }

    if (reverse!) {
      final start =
          radians(360 * startAngleFixedMargin - 90.0 + fixedStartAngle);
      final end = radians(-progress! * startAngleFixedMargin);
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        start as double,
        end as double,
        false,
        _paintLine,
      );
    } else {
      final start = radians(-90.0 + fixedStartAngle);
      final end = radians(progress! * startAngleFixedMargin);
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        start as double,
        end as double,
        false,
        _paintLine,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

num radians(num deg) => deg * (math.pi / 180.0);
