import 'package:flutter/material.dart';

import 'custom shapes/circle_painter.dart';

enum CircularStrokeCap { butt, round, square }

enum ArcType {
  half,
  full,
}

// ignore: must_be_immutable
class CircularPercentIndicator extends StatefulWidget {
  final double percent;
  final double radius;
  final double lineWidth;
  final double backgroundWidth;
  final Color fillColor;
  final Color backgroundColor;
  Color? get progressColor => _progressColor;
  Color? _progressColor;
  final bool animation;
  final int animationDuration;
  final Widget? header;
  final Widget? footer;
  final Widget? center;
  final LinearGradient? linearGradient;
  final CircularStrokeCap? circularStrokeCap;
  final double startAngle;
  final bool animateFromLastPercent;
  final bool addAutomaticKeepAlive;
  final ArcType? arcType;
  final Color? arcBackgroundColor;
  final bool reverse;
  final MaskFilter? maskFilter;
  final Curve curve;
  final bool restartAnimation;
  final VoidCallback? onAnimationEnd;
  final Widget? widgetIndicator;
  final bool rotateLinearGradient;

  CircularPercentIndicator(
      {Key? key,
      this.percent = 0.0,
      this.lineWidth = 5.0,
      this.startAngle = 0.0,
      required this.radius,
      this.fillColor = Colors.transparent,
      this.backgroundColor = const Color(0xFFB8C7CB),
      Color? progressColor,
      this.backgroundWidth = -1,
      this.linearGradient,
      this.animation = false,
      this.animationDuration = 500,
      this.header,
      this.footer,
      this.center,
      this.addAutomaticKeepAlive = true,
      this.circularStrokeCap,
      this.arcBackgroundColor,
      this.arcType,
      this.animateFromLastPercent = false,
      this.reverse = false,
      this.curve = Curves.linear,
      this.maskFilter,
      this.restartAnimation = false,
      this.onAnimationEnd,
      this.widgetIndicator,
      this.rotateLinearGradient = false})
      : super(key: key) {
    if (linearGradient != null && progressColor != null) {
      throw ArgumentError(
          'Cannot provide both linearGradient and progressColor');
    }
    _progressColor = progressColor ?? Colors.red;

    assert(startAngle >= 0.0);
    if (percent < 0.0 || percent > 1.0) {
      throw Exception('Percent value must be a double between 0.0 and 1.0');
    }

    if (arcType == null && arcBackgroundColor != null) {
      throw ArgumentError('arcType is required when you arcBackgroundColor');
    }
  }

  @override
  _CircularPercentIndicatorState createState() =>
      _CircularPercentIndicatorState();
}

class _CircularPercentIndicatorState extends State<CircularPercentIndicator>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _animationController;
  late Animation _animation;
  double _percent = 0.0;

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController!.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    if (widget.animation) {
      _animationController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: widget.animationDuration));
      _animation = Tween(begin: 0.0, end: widget.percent).animate(
        CurvedAnimation(parent: _animationController!, curve: widget.curve),
      )..addListener(() {
          setState(() {
            _percent = _animation.value;
          });
          if (widget.restartAnimation && _percent == 1.0) {
            _animationController!.repeat(min: 0, max: 1.0);
          }
        });
      _animationController!.addStatusListener((status) {
        if (widget.onAnimationEnd != null &&
            status == AnimationStatus.completed) {
          widget.onAnimationEnd!();
        }
      });
      _animationController!.forward();
    } else {
      _updateProgress();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(CircularPercentIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent ||
        oldWidget.startAngle != widget.startAngle) {
      if (_animationController != null) {
        _animationController!.duration =
            Duration(milliseconds: widget.animationDuration);
        _animation = Tween(
                begin: widget.animateFromLastPercent ? oldWidget.percent : 0.0,
                end: widget.percent)
            .animate(
          CurvedAnimation(parent: _animationController!, curve: widget.curve),
        );
        _animationController!.forward(from: 0.0);
      } else {
        _updateProgress();
      }
    }
  }

  void _updateProgress() {
    setState(() {
      _percent = widget.percent;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<Widget> items = <Widget>[];
    if (widget.header != null) {
      items.add(widget.header!);
    }
    items.add(
      SizedBox(
        height: widget.radius + widget.lineWidth,
        width: widget.radius,
        child: Stack(
          children: [
            CustomPaint(
              painter: CirclePainter(
                  progress: _percent * 360,
                  progressColor: widget.progressColor!,
                  backgroundColor: widget.backgroundColor,
                  startAngle: widget.startAngle,
                  circularStrokeCap: widget.circularStrokeCap,
                  radius: (widget.radius / 2) - widget.lineWidth / 2,
                  lineWidth: widget.lineWidth,
                  backgroundWidth: widget.backgroundWidth >= 0.0
                      ? (widget.backgroundWidth)
                      : widget.lineWidth,
                  arcBackgroundColor: widget.arcBackgroundColor,
                  arcType: widget.arcType,
                  reverse: widget.reverse,
                  linearGradient: widget.linearGradient,
                  maskFilter: widget.maskFilter,
                  rotateLinearGradient: widget.rotateLinearGradient),
              child: (widget.center != null)
                  ? Center(child: widget.center)
                  : Container(),
            ),
            if (widget.widgetIndicator != null && widget.animation)
              Positioned.fill(
                child: Transform.rotate(
                  angle: radians(
                      (widget.circularStrokeCap != CircularStrokeCap.butt &&
                              widget.reverse)
                          ? -15
                          : 0) as double,
                  child: Transform.rotate(
                    angle: radians((widget.reverse ? -360 : 360) * _percent)
                        as double,
                    child: Transform.translate(
                      offset: Offset(
                        (widget.circularStrokeCap != CircularStrokeCap.butt)
                            ? widget.lineWidth / 2
                            : 0,
                        -widget.radius / 2 + widget.lineWidth / 2,
                      ),
                      child: widget.widgetIndicator,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (widget.footer != null) {
      items.add(widget.footer!);
    }

    return Material(
      color: widget.fillColor,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: items,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.addAutomaticKeepAlive;
}
