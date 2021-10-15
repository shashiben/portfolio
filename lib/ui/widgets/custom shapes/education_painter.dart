import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  final double? verticalHeight, horizontalWidth;
  final bool isFirst;
  final double indicatorSize;
  final Color indicatorColor;
  final Color lineColor;

  RPSCustomPainter(
      {this.verticalHeight,
      this.horizontalWidth,
      this.isFirst = false,
      this.lineColor = Colors.grey,
      this.indicatorColor = Colors.blue,
      this.indicatorSize = 10});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint_0 = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.2;

    final Path path_0 = Path();
    final paint1 = Paint()
      ..color = indicatorColor
      ..style = PaintingStyle.fill;
    path_0.moveTo(5, 0);
    path_0.lineTo(5, verticalHeight!);
    path_0.lineTo(horizontalWidth!, verticalHeight!);

    canvas.drawPath(path_0, paint_0);
    canvas.drawCircle(
        Offset(5, isFirst ? 0 : verticalHeight! * 0.3), indicatorSize, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
