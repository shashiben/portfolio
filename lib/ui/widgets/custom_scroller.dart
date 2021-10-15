import 'package:flutter/material.dart';
import '../../core/utils/ScreenUiHelper.dart';

class CustomScroller extends StatelessWidget {
  const CustomScroller({
    this.width = 24,
    this.height = 70,
    this.padding = const EdgeInsets.all(0),
    this.duration = 800,
    this.borderRadius = 20,
    this.onUpTap,
    this.onDownTap,
    this.topController,
    this.centerChild,
    this.bottomController,
  });

  final EdgeInsetsGeometry padding;
  final double width;
  final int duration;
  final double height;
  final double borderRadius;
  final GestureTapCallback? onUpTap;
  final GestureTapCallback? onDownTap;
  final Widget? topController;
  final Widget? bottomController;
  final Widget? centerChild;

  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: height),
        duration: Duration(milliseconds: duration),
        child: Container(
          color: uiHelper.primaryColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: onUpTap,
                  child: topController ??
                      const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                centerChild ??
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: 6,
                        height: 6,
                        color: Colors.white,
                      ),
                    ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: onDownTap,
                  child: bottomController ??
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                )
              ],
            ),
          ),
        ),
        builder: (BuildContext context, double value, Widget? child) {
          return Container(
            width: width,
            height: value,
            color: Colors.red,
            child: child,
          );
        },
      ),
    );
  }
}
