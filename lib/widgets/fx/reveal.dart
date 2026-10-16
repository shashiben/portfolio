import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../app/theme/app_motion.dart';
import 'fx_common.dart';

/// Fades, slides and wipes [child] in the first time it becomes visible.
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.delay = Duration.zero, this.begin = const Offset(0, 0.08)});

  final Widget child;
  final Duration delay;

  /// Starting offset as a fraction of the child's size.
  final Offset begin;

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
    return FxVisibility(
      onShow: _start,
      child: FadeTransition(
        opacity: _curved,
        child: SlideTransition(
          position: _slide,
          child: ClipRect(
            clipper: _WipeClipper(_curved),
            clipBehavior: _done ? Clip.none : Clip.hardEdge,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _WipeClipper extends CustomClipper<Rect> {
  _WipeClipper(this.progress) : super(reclip: progress);

  final Animation<double> progress;

  @override
  Rect getClip(Size size) {
    final t = (progress.value * 1.35).clamp(0.0, 1.0);
    return Rect.fromLTWH(0, 0, size.width, size.height * t);
  }

  @override
  bool shouldReclip(covariant _WipeClipper oldClipper) => oldClipper.progress != progress;
}
