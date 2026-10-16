import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';
import '../../app/theme/app_theme_colors.dart';
import 'fx_common.dart';

/// Leans toward the pointer and plays an expanding ring before calling [onTap].
class MagneticButton extends StatefulWidget {
  const MagneticButton({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> with TickerProviderStateMixin {
  static const double _maxPull = 8;

  late final AnimationController _hover = AnimationController(vsync: this, duration: AppMotion.short);
  late final Animation<double> _hoverCurved = CurvedAnimation(parent: _hover, curve: AppMotion.easeOut);
  late final AnimationController _ring = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  final ValueNotifier<Offset> _pull = ValueNotifier<Offset>(Offset.zero);
  late final Listenable _magnet = Listenable.merge([_hoverCurved, _pull]);

  void _onHover(PointerEvent e) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.isEmpty) return;
    final s = box.size;
    final dx = (e.localPosition.dx / s.width * 2 - 1).clamp(-1.0, 1.0);
    final dy = (e.localPosition.dy / s.height * 2 - 1).clamp(-1.0, 1.0);
    _pull.value = Offset(dx * _maxPull, dy * _maxPull);
  }

  Future<void> _onTap() async {
    if (widget.onTap == null) return;
    if (fxReduceMotion(context)) {
      widget.onTap!();
      return;
    }
    try {
      await _ring.forward(from: 0).orCancel;
    } on TickerCanceled {
      return;
    }
    if (mounted) widget.onTap?.call();
  }

  @override
  void dispose() {
    _hover.dispose();
    _ring.dispose();
    _pull.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = fxReduceMotion(context);
    final tappable = widget.onTap != null;
    Widget content = widget.child;
    if (!reduce) {
      content = AnimatedBuilder(
        animation: _magnet,
        builder: (context, child) => Transform.translate(offset: _pull.value * _hoverCurved.value, child: child),
        child: RepaintBoundary(
          child: CustomPaint(
            foregroundPainter: _RingPainter(progress: _ring, color: context.appColors.accent),
            child: RepaintBoundary(child: widget.child),
          ),
        ),
      );
    }
    return MouseRegion(
      cursor: tappable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: reduce ? null : (_) => _hover.forward(),
      onHover: reduce ? null : _onHover,
      onExit: reduce ? null : (_) => _hover.reverse(),
      child: Semantics(
        button: tappable,
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: tappable ? _onTap : null, child: content),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.color})
    : _halo = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
      _core = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
      super(repaint: progress);

  final Animation<double> progress;
  final Color color;
  final Paint _halo;
  final Paint _core;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t <= 0 || t >= 1 || size.isEmpty) return;
    final e = AppMotion.easeOut.transform(t);
    final fade = 1 - t;
    final radius = size.shortestSide * 0.3 + size.longestSide * 0.45 * e;
    final center = size.center(Offset.zero);
    _halo.color = color.withValues(alpha: 0.18 * fade);
    _core.color = color.withValues(alpha: 0.9 * fade);
    canvas.drawCircle(center, radius, _halo);
    canvas.drawCircle(center, radius, _core);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.color != color || old.progress != progress;
}
