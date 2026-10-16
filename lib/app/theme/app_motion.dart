import 'package:flutter/widgets.dart';

abstract final class AppMotion {
  static const Duration micro = Duration(milliseconds: 140);
  static const Duration short = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 360);
  static const Duration long = Duration(milliseconds: 560);
  static const Duration transform = Duration(milliseconds: 900);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOutCubic;
  static const Curve spring = Curves.easeOutBack;

  static bool reduceMotion(BuildContext context) => MediaQuery.disableAnimationsOf(context);
}
