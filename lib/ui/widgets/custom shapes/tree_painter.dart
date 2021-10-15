import 'package:flutter/material.dart';

class TreePainter extends CustomPainter {
  TreePainter({
    this.veinsStrokeWidth = 5,
    this.jointsStrokeWidth = 5,
    this.innerJointRadius = 7,
    this.outerJointRadius = 10,
    this.stalk = 0.1,
  }) : assert(stalk <= 1 || stalk >= 0);

  final double veinsStrokeWidth;
  final double stalk;
  final double jointsStrokeWidth;
  final double innerJointRadius;
  final double outerJointRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint _paint = Paint()
      ..strokeWidth = veinsStrokeWidth
      ..color = const Color(0xFFB5B8BC)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final verticalLineStartingPoint = Offset(size.width * 0.5, size.height * 0.0);
    final verticalLineEndPoint = Offset(size.width * 0.5, size.height);

    final horizontalLineStartingPoint =
        Offset(size.width * (0.5 - (stalk / 2)), size.height * 0.5);
    final horizontalLineEndPoint =
        Offset(size.width * (0.5 + ((stalk / 2))), size.height * 0.5);

    //draws vertical line
    canvas.drawLine(verticalLineStartingPoint, verticalLineEndPoint, _paint);
    //draws horizontal line
    canvas.drawLine(
      horizontalLineStartingPoint,
      horizontalLineEndPoint,
      _paint,
    );

    final Paint _circlePaint = Paint()
      ..strokeWidth = jointsStrokeWidth
      ..color = const Color(0xFFB5B8BC)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, outerJointRadius, _circlePaint);

    _circlePaint.color = const Color(0xFF303E48);
    canvas.drawCircle(center, innerJointRadius, _circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
