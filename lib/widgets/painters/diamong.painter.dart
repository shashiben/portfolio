import 'package:flutter/material.dart';

class DiamondPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width * 0.5, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
