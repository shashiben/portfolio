import 'dart:async';

import 'package:flutter/material.dart';


typedef Builder = Widget Function(
    BuildContext context, AnimationController animationController);

class AnimationExecutor extends StatefulWidget {
  final Duration duration;
  final Duration delay;
  final Builder builder;

  const AnimationExecutor({
    Key key,
    @required this.duration,
    this.delay = Duration.zero,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  @override
  _AnimationExecutorState createState() => _AnimationExecutorState();
}

class _AnimationExecutorState extends State<AnimationExecutor>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(duration: widget.duration, vsync: this);

    if (AnimationLimiter.shouldRunAnimation(context) ?? true) {
      _timer = Timer(widget.delay, () => _animationController.forward());
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: _animationController,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return widget.builder(context, _animationController);
  }
}

class AnimationLimiter extends StatefulWidget {
  final Widget child;
  const AnimationLimiter({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  _AnimationLimiterState createState() => _AnimationLimiterState();

  static bool shouldRunAnimation(BuildContext context) {
    return _AnimationLimiterProvider.of(context)?.shouldRunAnimation;
  }
}

class _AnimationLimiterState extends State<AnimationLimiter> {
  bool _shouldRunAnimation = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration value) {
      setState(() {
        _shouldRunAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AnimationLimiterProvider(
      shouldRunAnimation: _shouldRunAnimation,
      child: widget.child,
    );
  }
}

class _AnimationLimiterProvider extends InheritedWidget {
  final bool shouldRunAnimation;

  _AnimationLimiterProvider({
    this.shouldRunAnimation,
    @required Widget child,
  })  : assert(child != null),
        super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static _AnimationLimiterProvider of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<_AnimationLimiterProvider>();
  }
}
