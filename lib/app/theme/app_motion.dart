import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const Duration micro = Duration(milliseconds: 140);
  static const Duration short = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 360);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOutCubic;
}
