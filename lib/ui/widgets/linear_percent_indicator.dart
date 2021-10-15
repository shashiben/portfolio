import 'package:flutter/material.dart';
import '../../core/utils/ScreenUiHelper.dart';

import 'custom shapes/linear_painter.dart';

enum LinearStrokeCap { butt, round, roundAll }

// ignore: must_be_immutable
class LinearPercentIndicator extends StatefulWidget {
  final double percent;
  final String? title;
  final double? width;
  final double lineHeight;
  final Color fillColor;
  final Color backgroundColor;
  Color? get progressColor => _progressColor;
  Color? _progressColor;
  final bool animation;
  final int animationDuration;
  final Widget? leading;
  final Widget? trailing;
  final Widget? center;
  final LinearStrokeCap? linearStrokeCap;
  final MainAxisAlignment alignment;
  final EdgeInsets padding;
  final bool animateFromLastPercent;
  final LinearGradient? linearGradient;
  final bool addAutomaticKeepAlive;
  final bool isRTL;
  final MaskFilter? maskFilter;
  final bool clipLinearGradient;

  final Curve curve;
  final bool restartAnimation;

  final VoidCallback? onAnimationEnd;

  LinearPercentIndicator({
    Key? key,
    this.title,
    this.fillColor = Colors.transparent,
    this.percent = 0.0,
    this.lineHeight = 5.0,
    this.width,
    this.backgroundColor = const Color(0xFFB8C7CB),
    this.linearGradient,
    Color? progressColor,
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

    if (percent < 0.0 || percent > 1.0) {
      throw Exception('Percent value must be a double between 0.0 and 1.0');
    }
  }

  @override
  _LinearPercentIndicatorState createState() => _LinearPercentIndicatorState();
}

class _LinearPercentIndicatorState extends State<LinearPercentIndicator>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _animationController;
  late Animation _animation;
  double _percent = 0.0;

  @override
  void dispose() {
    _animationController?.dispose();
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
  void didUpdateWidget(LinearPercentIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
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

  _updateProgress() {
    setState(() {
      _percent = widget.percent;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<Widget> items = [];
    if (widget.leading != null) {
      items.add(widget.leading!);
    }
    final hasSetWidth = widget.width != null;
    final containerWidget = Container(
      width: hasSetWidth ? widget.width : double.infinity,
      height: widget.lineHeight,
      padding: widget.padding,
      child: CustomPaint(
        painter: LinearPainter(
          isRTL: widget.isRTL,
          progress: _percent,
          center: widget.center,
          progressColor: widget.progressColor,
          linearGradient: widget.linearGradient,
          backgroundColor: widget.backgroundColor,
          linearStrokeCap: widget.linearStrokeCap,
          lineWidth: widget.lineHeight,
          maskFilter: widget.maskFilter,
          clipLinearGradient: widget.clipLinearGradient,
        ),
        child: (widget.center != null)
            ? Center(child: widget.center)
            : Container(),
      ),
    );

    if (hasSetWidth) {
      items.add(containerWidget);
    } else {
      items.add(Expanded(
        child: containerWidget,
      ));
    }
    if (widget.trailing != null) {
      items.add(widget.trailing!);
    }
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);

    return Material(
      color: Colors.transparent,
      child: Container(
          color: widget.fillColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title!,
                  style: uiHelper.title,
                ),
              ),
              Row(
                mainAxisAlignment: widget.alignment,
                children: items,
              ),
              const SizedBox(height: 10),
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => widget.addAutomaticKeepAlive;
}
