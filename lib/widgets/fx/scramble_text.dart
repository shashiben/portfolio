import 'package:flutter/material.dart';

import 'fx_common.dart';

class ScrambleText extends StatefulWidget {
  const ScrambleText(this.text, {super.key, this.style, this.reshuffleOnHover = true, this.duration});

  final String text;
  final TextStyle? style;
  final bool reshuffleOnHover;
  final Duration? duration;

  @override
  State<ScrambleText> createState() => _ScrambleTextState();
}

class _ScrambleTextState extends State<ScrambleText> with SingleTickerProviderStateMixin {
  static const String _glyphs = '01ΔΩ◇△§#';
  static const Duration _hoverDuration = Duration(milliseconds: 420);
  static const int _steps = 28;

  late final AnimationController _controller = AnimationController(vsync: this, duration: _decodeDuration);
  bool _played = false;

  Duration get _decodeDuration => widget.duration ?? const Duration(milliseconds: 900);

  void _play(Duration duration) {
    if (fxReduceMotion(context)) return;
    _controller.duration = duration;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _frame(double t) {
    final text = widget.text;
    final revealed = (t * text.length).floor();
    final step = (t * _steps).floor();
    final buf = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final c = text[i];
      if (i < revealed || c == ' ' || c == '\n') {
        buf.write(c);
      } else {
        buf.write(_glyphs[(i * 7 + step * 13 + i * step) % _glyphs.length]);
      }
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = fxReduceMotion(context);
    return MouseRegion(
      onEnter: (_) {
        if (widget.reshuffleOnHover && _played && !_controller.isAnimating) _play(_hoverDuration);
      },
      child: Semantics(
        label: widget.text,
        child: ExcludeSemantics(
          child: FxVisibility(
            onShow: () {
              if (_played) return;
              _played = true;
              _play(_decodeDuration);
            },
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  if (reduce || _controller.isCompleted) return Text(widget.text, style: widget.style);
                  return FxTextSlot(sizing: widget.text, display: _frame(_controller.value), style: widget.style);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
