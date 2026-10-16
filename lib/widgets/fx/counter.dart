import 'package:flutter/widgets.dart';

import '../../app/theme/app_motion.dart';
import 'fx_common.dart';

/// Counts from 0 to [value] the first time it becomes visible.
class CountUp extends StatefulWidget {
  const CountUp({super.key, required this.value, this.style, this.suffix = '', this.duration});

  final num value;
  final TextStyle? style;
  final String suffix;
  final Duration? duration;

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration ?? const Duration(milliseconds: 1200),
  );
  late final Animation<double> _curved = CurvedAnimation(parent: _controller, curve: AppMotion.easeOut);
  num _from = 0;

  int get _decimals {
    final v = widget.value;
    if (v is int) return 0;
    final s = v.toString();
    final dot = s.indexOf('.');
    return dot < 0 ? 0 : (s.length - dot - 1).clamp(0, 2);
  }

  String _format(num v) => v is int || _decimals == 0 ? v.round().toString() : v.toStringAsFixed(_decimals);

  @override
  void didUpdateWidget(covariant CountUp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.value > 0) {
      _from = _from + (oldWidget.value - _from) * _curved.value;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final finalText = '${_format(widget.value)}${widget.suffix}';
    if (fxReduceMotion(context)) return Text(finalText, style: widget.style);
    return Semantics(
      label: finalText,
      child: ExcludeSemantics(
        child: FxVisibility(
          onShow: () {
            if (_controller.value == 0 && !_controller.isAnimating) _controller.forward();
          },
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _curved,
              builder: (context, _) {
                final v = _from + (widget.value - _from) * _curved.value;
                return FxTextSlot(sizing: finalText, display: '${_format(v)}${widget.suffix}', style: widget.style);
              },
            ),
          ),
        ),
      ),
    );
  }
}
