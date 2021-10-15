import 'package:flutter/material.dart';
import '../../core/utils/ScreenUiHelper.dart';

class ContentWrapper extends StatelessWidget {
  const ContentWrapper({
    this.width,
    this.height,
    this.color ,
    this.gradient,
    this.child,
  });

  final double? width;
  final double? height;
  final Color? color;
  final Gradient? gradient;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper=ScreenUiHelper.fromContext(context);
    return Container(
      width: width ??uiHelper.width,
      height: height ?? uiHelper.height,
      decoration: BoxDecoration(color: color, gradient: gradient),
      child: child,
    );
  }
}
