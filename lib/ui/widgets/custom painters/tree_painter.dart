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
    Paint _paint = Paint()
      ..strokeWidth = veinsStrokeWidth
      ..color = Color(0xFFB5B8BC)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    var verticalLineStartingPoint = Offset(size.width * 0.5, size.height * 0.0);
    var verticalLineEndPoint = Offset(size.width * 0.5, size.height);

    var horizontalLineStartingPoint =
        Offset(size.width * (0.5 - (stalk / 2)), size.height * 0.5);
    var horizontalLineEndPoint =
        Offset(size.width * (0.5 + ((stalk / 2))), size.height * 0.5);

    //draws vertical line
    canvas.drawLine(verticalLineStartingPoint, verticalLineEndPoint, _paint);
    //draws horizontal line
    canvas.drawLine(
      horizontalLineStartingPoint,
      horizontalLineEndPoint,
      _paint,
    );

    Paint _circlePaint = Paint()
      ..strokeWidth = jointsStrokeWidth
      ..color = Color(0xFFB5B8BC)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, outerJointRadius, _circlePaint);

    _circlePaint..color = Color(0xFF303E48);
    canvas.drawCircle(center, innerJointRadius, _circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
