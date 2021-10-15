import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ScalingHelper {
  ScalingHelper({this.width = 750});

  // width of the current device
  double width;

  // default scale set to 1.0
  double scale = 1.0;

  // if there is width, we'll use it or we can use default one
  void init({double? width}) {
    this.width = width ?? this.width;
  }

  double size(double value) {
    return _t(value) / window.devicePixelRatio;
  }

  EdgeInsets fromLTRB(double left, double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(
        size(left), size(top), size(right), size(bottom));
  }

  EdgeInsets all(double value) {
    return EdgeInsets.all(size(value));
  }

  EdgeInsets only(
      {double left = 0.0,
      double top = 0.0,
      double right = 0.0,
      double bottom = 0.0}) {
    return EdgeInsets.only(
      left: size(left),
      top: size(top),
      right: size(right),
      bottom: size(bottom),
    );
  }

  double _t(double value) {
    if (value > -1e-6 && value < 1e-6) {
      return value;
    }
    // Adapt small ones for landscape
    final double devWidth =
        min(window.physicalSize.width, window.physicalSize.height);

    final double s = devWidth / width;

    final double r = value * s;

    return r * scale;
  }
}
