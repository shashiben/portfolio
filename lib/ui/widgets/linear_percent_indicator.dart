import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';


enum LinearStrokeCap { butt, round, roundAll }

// ignore: must_be_immutable
class LinearPercentIndicator extends StatefulWidget {
  final double percent;
  final String title;
  final double width;
  final double lineHeight;
  final Color fillColor;
  final Color backgroundColor;
  Color get progressColor => _progressColor;
  Color _progressColor;
  final bool animation;
  final int animationDuration;
  final Widget leading;
  final Widget trailing;
  final Widget center;
  final LinearStrokeCap linearStrokeCap;
  final MainAxisAlignment alignment;
  final EdgeInsets padding;
  final bool animateFromLastPercent;
  final LinearGradient linearGradient;
  final bool addAutomaticKeepAlive;
  final bool isRTL;
  final MaskFilter maskFilter;
  final bool clipLinearGradient;

  final Curve curve;
  final bool restartAnimation;

  final VoidCallback onAnimationEnd;

  LinearPercentIndicator({
    Key key,
    this.title,
    this.fillColor = Colors.transparent,
    this.percent = 0.0,
    this.lineHeight = 5.0,
    this.width,
    this.backgroundColor = const Color(0xFFB8C7CB),
    this.linearGradient,
    Color progressColor,
    this.animation = false,
    this.animationDuration = 500,
    this.animateFromLastPercent = false,
    this.isRTL = false,
    this.leading,
    this.trailing,
    this.center,
    this.addAutomaticKeepAlive = true,
    this.linearStrokeCap,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
    this.alignment = MainAxisAlignment.start,
    this.maskFilter,
    this.clipLinearGradient = false,
    this.curve = Curves.linear,
    this.restartAnimation = false,
    this.onAnimationEnd,
  }) : super(key: key) {
    if (linearGradient != null && progressColor != null) {
      throw ArgumentError(
          'Cannot provide both linearGradient and progressColor');
    }
    _progressColor = progressColor ?? Colors.red;

    assert(curve != null);

    if (percent < 0.0 || percent > 1.0) {
      throw new Exception("Percent value must be a double between 0.0 and 1.0");
    }
  }

  @override
  _LinearPercentIndicatorState createState() => _LinearPercentIndicatorState();
}

class _LinearPercentIndicatorState extends State<LinearPercentIndicator> {
  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    return Material(
      color: Colors.transparent,
      child: new Container(
          color: widget.fillColor ?? uiHelper.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: uiHelper.title,
                ),
              ),
              NeumorphicProgress(
                percent: widget.percent,
                style: ProgressStyle(
                    border: NeumorphicBorder(),
                    depth: -8,
                    lightSource: LightSource.topRight),
              ),
              SizedBox(height: 10),
            ],
          )),
    );
  }
}
