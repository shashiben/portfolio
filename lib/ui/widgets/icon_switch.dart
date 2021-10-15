import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimateIcons extends StatefulWidget {
  const AnimateIcons({
    /// The IconData that will be visible before animation Starts
    required this.startIcon,

    /// The IconData that will be visible after animation ends

    /// The callback on startIcon Press
    /// It should return a bool
    /// If true is returned it'll animate to the end icon
    /// if false is returned it'll not animate to the end icons
    required this.onStartIconPress,

    /// The callback on endIcon Press
    /// /// It should return a bool
    /// If true is returned it'll animate to the end icon
    /// if false is returned it'll not animate to the end icons
    required this.onEndIconPress,

    /// The size of the icon that are to be shown.
    this.size,

    /// AnimateIcons controller
    required this.controller,

    /// The color to be used for the [startIcon]
    this.startIconColor,

    // The color to be used for the [endIcon]
    this.endIconColor,

    /// The duration for which the animation runs
    this.duration,

    /// If the animation runs in the clockwise or anticlockwise direction
    this.clockwise,

    /// This is the tooltip that will be used for the [startIcon]
    this.startTooltip,

    /// This is the tooltip that will be used for the [endIcon]
    this.endTooltip,
  });
  final IconData startIcon;
  final bool Function() onStartIconPress, onEndIconPress;
  final Duration? duration;
  final bool? clockwise;
  final double? size;
  final Color? startIconColor, endIconColor;
  final AnimateIconController controller;
  final String? startTooltip, endTooltip;

  @override
  _AnimateIconsState createState() => _AnimateIconsState();
}

class _AnimateIconsState extends State<AnimateIcons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(seconds: 1),
    );
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    initControllerFunctions();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

 void initControllerFunctions() {
    widget.controller.animateToEnd = () {
      if (mounted) {
        _controller.forward();
        return true;
      } else {
        return false;
      }
    };
    widget.controller.animateToStart = () {
      if (mounted) {
        _controller.reverse();
        return true;
      } else {
        return false;
      }
    };
    widget.controller.isStart = () => _controller.value == 0.0;
    widget.controller.isEnd = () => _controller.value == 1.0;
  }

  _onStartIconPress() {
    widget.onStartIconPress();
    _controller.forward();
  }

  _onEndIconPress() {
    widget.onStartIconPress();
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final double x = _controller.value;
    final double y = 1.0 - _controller.value;
    final double angleX = math.pi / 180 * (180 * x);
    final double angleY = math.pi / 180 * (180 * y);

    Widget first() {
      final icon = Icon(widget.startIcon, size: widget.size);
      return Transform.rotate(
        angle: widget.clockwise ?? false ? angleX : -angleX,
        child: Opacity(
          opacity: y,
          child: IconButton(
            iconSize: widget.size ?? 24.0,
            color: widget.startIconColor ?? Theme.of(context).primaryColor,
            disabledColor: Colors.grey.shade500,
            icon: widget.startTooltip == null
                ? icon
                : Tooltip(
                    message: widget.startTooltip,
                    child: icon,
                  ),
            onPressed: _onStartIconPress,
          ),
        ),
      );
    }

    Widget second() {
      final icon = Icon(widget.startIcon);
      return Transform.rotate(
        angle: widget.clockwise ?? false ? -angleY : angleY,
        child: Opacity(
          opacity: x,
          child: IconButton(
            iconSize: widget.size ?? 24.0,
            color: widget.endIconColor ?? Theme.of(context).primaryColor,
            disabledColor: Colors.grey.shade500,
            icon: widget.endTooltip == null
                ? icon
                : Tooltip(
                    message: widget.endTooltip,
                    child: icon,
                  ),
            onPressed: _onEndIconPress,
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (x == 1 && y == 0) second() else first(),
        if (x == 0 && y == 1) first() else second(),
      ],
    );
  }
}

class AnimateIconController {
  bool Function()? animateToStart, animateToEnd;
  bool Function()? isStart, isEnd;
}
