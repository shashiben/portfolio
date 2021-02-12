import 'dart:math';

import 'package:flutter/material.dart';

import 'configuration.dart';

class FadeInAnimation extends StatelessWidget {
  final Duration duration;
  final Duration delay;
  final Widget child;
  const FadeInAnimation({
    Key key,
    this.duration,
    this.delay,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfigurator(
      duration: duration,
      delay: delay,
      animatedChildBuilder: _fadeInAnimation,
    );
  }

  Widget _fadeInAnimation(Animation<double> animation) {
    final _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(0.0, 1.0, curve: Curves.ease),
      ),
    );

    return Opacity(
      opacity: _opacityAnimation.value,
      child: child,
    );
  }
}

enum FlipAxis {
  x,
  y,
}

class FlipAnimation extends StatelessWidget {
  final Duration duration;
  final Duration delay;
  final FlipAxis flipAxis;
  final Widget child;
  const FlipAnimation({
    Key key,
    this.duration,
    this.delay,
    this.flipAxis = FlipAxis.x,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfigurator(
      duration: duration,
      delay: delay,
      animatedChildBuilder: _flipAnimation,
    );
  }

  Widget _flipAnimation(Animation<double> animation) {
    final _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(0.0, 1.0, curve: Curves.ease),
      ),
    );

    Matrix4 _computeTransformationMatrix() {
      var radians = (1 - _flipAnimation.value) * pi / 2;

      switch (flipAxis) {
        case FlipAxis.y:
          return Matrix4.rotationY(radians);
        case FlipAxis.x:
        default:
          return Matrix4.rotationX(radians);
      }
    }

    return Transform(
      transform: _computeTransformationMatrix(),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class ScaleAnimation extends StatelessWidget {
  final Duration duration;
  final Duration delay;
  final double scale;
  final Widget child;
  const ScaleAnimation({
    Key key,
    this.duration,
    this.delay,
    this.scale = 0.0,
    @required this.child,
  })  : assert(child != null),
        assert(scale != null && scale >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfigurator(
      duration: duration,
      delay: delay,
      animatedChildBuilder: _landingAnimation,
    );
  }

  Widget _landingAnimation(Animation<double> animation) {
    final _landingAnimation = Tween<double>(begin: scale, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(0.0, 1.0, curve: Curves.ease),
      ),
    );

    return Transform.scale(
      scale: _landingAnimation.value,
      child: child,
    );
  }
}

class SlideAnimation extends StatelessWidget {
  final Duration duration;
  final Duration delay;
  final double verticalOffset;
  final double horizontalOffset;
  final Widget child;
  const SlideAnimation({
    Key key,
    this.duration,
    this.delay,
    double verticalOffset,
    this.horizontalOffset = 0.0,
    @required this.child,
  })  : verticalOffset = (verticalOffset == null && horizontalOffset == null)
            ? 50.0
            : (verticalOffset ?? 0.0),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfigurator(
      duration: duration,
      delay: delay,
      animatedChildBuilder: _slideAnimation,
    );
  }

  Widget _slideAnimation(Animation<double> animation) {
    Animation<double> offsetAnimation(
        double offset, Animation<double> animation) {
      return Tween<double>(begin: offset, end: 0.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(0.0, 1.0, curve: Curves.ease),
        ),
      );
    }

    return Transform.translate(
      offset: Offset(
        horizontalOffset == 0.0
            ? 0.0
            : offsetAnimation(horizontalOffset, animation).value,
        verticalOffset == 0.0
            ? 0.0
            : offsetAnimation(verticalOffset, animation).value,
      ),
      child: child,
    );
  }
}
