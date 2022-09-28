import 'package:flutter/material.dart';

enum TriangleType { left, right, top, bottom }

class TriangleClipperr extends CustomClipper<Path> {
  final TriangleType type;

  TriangleClipperr({this.type = TriangleType.left});
  @override
  Path getClip(Size size) {
    if (type == TriangleType.left) {
      return Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, size.height * 0.5)
        ..lineTo(0, size.height)
        ..lineTo(0, 0)
        ..close();
    } else if (type == TriangleType.right) {
      return Path()
        ..moveTo(size.width, 0)
        ..lineTo(0, size.height * 0.5)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, 0)
        ..close();
    } else if (type == TriangleType.top) {
      return Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width * 0.5, size.height)
        ..lineTo(0, 0)
        ..close();
    } else {
      return Path()
        ..moveTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width * 0.5, 0)
        ..lineTo(0, size.height)
        ..close();
    }
  }

  @override
  bool shouldReclip(TriangleClipperr oldClipper) => false;
}
