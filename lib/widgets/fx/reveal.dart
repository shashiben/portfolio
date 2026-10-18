import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../app/theme/app_motion.dart';
import 'fx_common.dart';

enum RevealKind { wipeUp, wipeLeft, scaleIn, irisIn }

/// Fades, slides and wipes [child] in the first time it becomes visible.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.begin = const Offset(0, 0.08),
    this.kind = RevealKind.wipeUp,
  });

  final Widget child;
  final Duration delay;

  /// Starting offset as a fraction of the child's size.
  final Offset begin;
  final RevealKind kind;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: AppMotion.long)
    ..addStatusListener(_onStatus);
  late final Animation<double> _curved = CurvedAnimation(parent: _controller, curve: AppMotion.easeOut);
  late Animation<Offset> _slide = Tween<Offset>(begin: widget.begin, end: Offset.zero).animate(_curved);
  Timer? _timer;
  bool _started = false;
  bool _done = false;

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_done) setState(() => _done = true);
  }

  void _start() {
    if (_started) return;
    _started = true;
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(covariant Reveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.begin != widget.begin) {
      _slide = Tween<Offset>(begin: widget.begin, end: Offset.zero).animate(_curved);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (fxReduceMotion(context)) return widget.child;
    final child = switch (widget.kind) {
      RevealKind.scaleIn => ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1).animate(_curved),
        child: widget.child,
      ),
      RevealKind.irisIn => ClipPath(clipper: _done ? null : _IrisClipper(_curved), child: widget.child),
      RevealKind.wipeLeft || RevealKind.wipeUp => ClipRect(
        clipper: _done ? null : _WipeClipper(_curved, horizontal: widget.kind == RevealKind.wipeLeft),
        clipBehavior: _done ? Clip.none : Clip.hardEdge,
        child: widget.child,
      ),
    };
    return FxVisibility(
      onShow: _start,
      child: FadeTransition(
        opacity: _curved,
        child: SlideTransition(position: _slide, child: child),
      ),
    );
  }
}

/// Staggers [children] in a column so callers don't hand-roll delays.
class RevealGroup extends StatelessWidget {
  const RevealGroup({
    super.key,
    required this.children,
    this.step = const Duration(milliseconds: 80),
    this.kind = RevealKind.wipeUp,
  });

  final List<Widget> children;
  final Duration step;
  final RevealKind kind;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (var i = 0; i < children.length; i++) Reveal(delay: step * i, kind: kind, child: children[i])],
    );
  }
}

class _WipeClipper extends CustomClipper<Rect> {
  _WipeClipper(this.progress, {required this.horizontal}) : super(reclip: progress);

  final Animation<double> progress;
  final bool horizontal;

  @override
  Rect getClip(Size size) {
    final t = (progress.value * 1.35).clamp(0.0, 1.0);
    if (horizontal) return Rect.fromLTWH(0, 0, size.width * t, size.height);
    return Rect.fromLTWH(0, 0, size.width, size.height * t);
  }

  @override
  bool shouldReclip(covariant _WipeClipper oldClipper) =>
      oldClipper.progress != progress || oldClipper.horizontal != horizontal;
}

class _IrisClipper extends CustomClipper<Path> {
  _IrisClipper(this.progress) : super(reclip: progress);

  final Animation<double> progress;

  @override
  Path getClip(Size size) {
    final t = progress.value.clamp(0.0, 1.0);
    final radius = size.longestSide * 0.75 * t;
    return Path()..addOval(Rect.fromCircle(center: size.center(Offset.zero), radius: radius));
  }

  @override
  bool shouldReclip(covariant _IrisClipper oldClipper) => oldClipper.progress != progress;
}
