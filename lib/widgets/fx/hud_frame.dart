import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';
import '../../app/theme/app_theme_colors.dart';
import 'fx_common.dart';

/// Chamfered HUD panel; hovering traces the border and brightens the fill.
class HudFrame extends StatefulWidget {
  const HudFrame({super.key, required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  State<HudFrame> createState() => _HudFrameState();
}

class _HudFrameState extends State<HudFrame> with SingleTickerProviderStateMixin {
  static const double _chamfer = 12;

  late final AnimationController _hover = AnimationController(vsync: this, duration: AppMotion.long);
  late final Animation<double> _curved = CurvedAnimation(parent: _hover, curve: AppMotion.easeOut);
  final _HudCache _cache = _HudCache(_chamfer);

  void _setHover(bool on) {
    if (fxReduceMotion(context)) {
      _hover.value = on ? 1 : 0;
    } else if (on) {
      _hover.forward();
    } else {
      _hover.reverse();
    }
  }

  @override
  void dispose() {
    _hover.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.appColors.accent;
    final tappable = widget.onTap != null;
    Widget panel = RepaintBoundary(
      child: CustomPaint(
        painter: _HudBackPainter(progress: _curved, cache: _cache, color: accent),
        foregroundPainter: _HudFrontPainter(progress: _curved, cache: _cache, color: accent),
        child: ClipPath(
          clipper: const _ChamferClipper(_chamfer),
          child: Padding(padding: widget.padding ?? const EdgeInsets.all(20), child: widget.child),
        ),
      ),
    );
    if (tappable) {
      panel = Semantics(
        button: true,
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: widget.onTap, child: panel),
      );
    }
    return MouseRegion(
      cursor: tappable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: panel,
    );
  }
}

Path _chamferPath(Size s, double c, double inset) {
  final l = inset, t = inset, r = s.width - inset, b = s.height - inset;
  return Path()
    ..moveTo(l + c, t)
    ..lineTo(r, t)
    ..lineTo(r, b - c)
    ..lineTo(r - c, b)
    ..lineTo(l, b)
    ..lineTo(l, t + c)
    ..close();
}

class _ChamferClipper extends CustomClipper<Path> {
  const _ChamferClipper(this.chamfer);

  final double chamfer;

  @override
  Path getClip(Size size) => _chamferPath(size, chamfer, 0);

  @override
  bool shouldReclip(covariant _ChamferClipper oldClipper) => oldClipper.chamfer != chamfer;
}

class _HudCache {
  _HudCache(this.chamfer);

  final double chamfer;
  Size? _size;
  late Path fill;
  late Path border;
  late ui.PathMetric borderMetric;
  final Path brackets = Path();

  void resolve(Size s) {
    if (_size == s) return;
    _size = s;
    fill = _chamferPath(s, chamfer, 0);
    border = _chamferPath(s, chamfer, 0.5);
    borderMetric = border.computeMetrics().first;
    const len = 10.0;
    const o = 4.0;
    brackets
      ..reset()
      ..moveTo(s.width - o - len, o)
      ..lineTo(s.width - o, o)
      ..lineTo(s.width - o, o + len)
      ..moveTo(o, s.height - o - len)
      ..lineTo(o, s.height - o)
      ..lineTo(o + len, s.height - o)
      ..moveTo(o + 2, chamfer + o + 2)
      ..lineTo(chamfer + o + 2, o + 2)
      ..moveTo(s.width - chamfer - o - 2, s.height - o - 2)
      ..lineTo(s.width - o - 2, s.height - chamfer - o - 2);
  }
}

class _HudBackPainter extends CustomPainter {
  _HudBackPainter({required this.progress, required this.cache, required this.color})
    : _fill = Paint(),
      super(repaint: progress);

  final Animation<double> progress;
  final _HudCache cache;
  final Color color;
  final Paint _fill;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    cache.resolve(size);
    _fill.color = color.withValues(alpha: 0.03 + 0.06 * progress.value);
    canvas.drawPath(cache.fill, _fill);
  }

  @override
  bool shouldRepaint(covariant _HudBackPainter old) => old.color != color || old.progress != progress;
}

class _HudFrontPainter extends CustomPainter {
  _HudFrontPainter({required this.progress, required this.cache, required this.color})
    : _border = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = color.withValues(alpha: 0.28),
      _traceHalo = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..color = color.withValues(alpha: 0.16),
      _trace = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = color,
      _bracket = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.square,
      super(repaint: progress);

  final Animation<double> progress;
  final _HudCache cache;
  final Color color;
  final Paint _border;
  final Paint _traceHalo;
  final Paint _trace;
  final Paint _bracket;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    cache.resolve(size);
    final t = progress.value;
    canvas.drawPath(cache.border, _border);
    if (t > 0) {
      final metric = cache.borderMetric;
      final trace = t >= 1 ? cache.border : metric.extractPath(0, metric.length * t);
      canvas.drawPath(trace, _traceHalo);
      canvas.drawPath(trace, _trace);
    }
    _bracket.color = color.withValues(alpha: 0.55 + 0.45 * t);
    canvas.drawPath(cache.brackets, _bracket);
  }

  @override
  bool shouldRepaint(covariant _HudFrontPainter old) => old.color != color || old.progress != progress;
}
