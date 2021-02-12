import 'package:flutter/material.dart';

import 'animation_executor.dart';

class AnimationConfiguration extends InheritedWidget {
  final int position;

  final Duration duration;

  final Duration delay;

  final int columnCount;

  const AnimationConfiguration.synchronized({
    Key key,
    this.duration = const Duration(milliseconds: 225),
    @required Widget child,
  })  : position = 0,
        delay = Duration.zero,
        columnCount = 1,
        assert(duration != null),
        assert(child != null),
        super(key: key, child: child);

  const AnimationConfiguration.staggeredList({
    Key key,
    @required this.position,
    this.duration = const Duration(milliseconds: 225),
    this.delay,
    @required Widget child,
  })  : columnCount = 1,
        assert(duration != null),
        assert(child != null),
        super(key: key, child: child);

  const AnimationConfiguration.staggeredGrid({
    Key key,
    @required this.position,
    this.duration = const Duration(milliseconds: 225),
    this.delay,
    @required this.columnCount,
    @required Widget child,
  })  : assert(duration != null),
        assert(columnCount != null && columnCount > 0),
        assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static List<Widget> toStaggeredList({
    Duration duration,
    Duration delay,
    @required Widget Function(Widget) childAnimationBuilder,
    @required List<Widget> children,
  }) =>
      children
          .asMap()
          .map((index, widget) {
            return MapEntry(
              index,
              AnimationConfiguration.staggeredList(
                position: index,
                duration: duration ?? const Duration(milliseconds: 225),
                delay: delay,
                child: childAnimationBuilder(widget),
              ),
            );
          })
          .values
          .toList();

  static AnimationConfiguration of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<AnimationConfiguration>();
  }
}

class AnimationConfigurator extends StatelessWidget {
  final Duration duration;
  final Duration delay;
  final Widget Function(Animation<double>) animatedChildBuilder;

  const AnimationConfigurator({
    Key key,
    this.duration,
    this.delay,
    @required this.animatedChildBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationConfiguration = AnimationConfiguration.of(context);

    if (animationConfiguration == null) {
      throw FlutterError.fromParts(
        <DiagnosticsNode>[
          ErrorSummary('Animation not wrapped in an AnimationConfiguration.'),
          ErrorDescription(
              'This error happens if you use an Animation that is not wrapped in an '
              'AnimationConfiguration.'),
          ErrorHint(
              'The solution is to wrap your Animation(s) with an AnimationConfiguration. '
              'Reminder: an AnimationConfiguration provides the configuration '
              'used as a base for every children Animation. Configuration made in AnimationConfiguration '
              'can be overridden in Animation children if needed.'),
        ],
      );
    }

    final _position = animationConfiguration.position ?? 0;
    final _duration = duration ?? animationConfiguration.duration;
    final _delay = delay ?? animationConfiguration.delay;
    final _columnCount = animationConfiguration.columnCount;

    return AnimationExecutor(
      duration: _duration,
      delay: stagger(_position, _duration, _delay, _columnCount),
      builder: (context, animationController) =>
          animatedChildBuilder(animationController),
    );
  }

  Duration stagger(
      int position, Duration duration, Duration delay, int columnCount) {
    var delayInMilliseconds =
        (delay == null ? duration.inMilliseconds ~/ 6 : delay.inMilliseconds);

    int _computeStaggeredGridDuration() {
      return (position ~/ columnCount + position % columnCount) *
          delayInMilliseconds;
    }

    int _computeStaggeredListDuration() {
      return position * delayInMilliseconds;
    }

    return Duration(
        milliseconds: columnCount > 1
            ? _computeStaggeredGridDuration()
            : _computeStaggeredListDuration());
  }
}
