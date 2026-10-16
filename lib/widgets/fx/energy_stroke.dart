import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';
import '../../app/theme/app_theme_colors.dart';
import 'fx_common.dart';

/// Irregular brush underline that wipes in under [child] once it becomes visible.
class EnergyStroke extends StatelessWidget {
  const EnergyStroke({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) =>
      _EnergyStroke(color: color ?? context.appColors.accent, reduceMotion: fxReduceMotion(context), child: child);
}

class _EnergyStroke extends StatefulWidget {
  const _EnergyStroke({required this.child, required this.color, required this.reduceMotion});

  final Widget child;
  final Color color;
  final bool reduceMotion;

  @override
  State<_EnergyStroke> createState() => _EnergyStrokeState();
}

class _EnergyStrokeState extends State<_EnergyStroke> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
    value: widget.reduceMotion ? 1 : 0,
  );
  late final Animation<double> _curved = CurvedAnimation(parent: _controller, curve: AppMotion.easeOut);
  final _BrushCache _cache = _BrushCache();

  @override
  void didUpdateWidget(covariant _EnergyStroke oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reduceMotion) _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FxVisibility(
      onShow: () {
        if (_controller.value < 1 && !_controller.isAnimating) _controller.forward();
      },
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BrushPainter(progress: _curved, cache: _cache, color: widget.color),
          child: widget.child,
        ),
      ),
    );
  }
}

class _BrushCache {
  static const int samples = 48;
  static final Float32List noise = () {
    final rnd = math.Random(42);
    final list = Float32List(samples * 2);
    for (var i = 0; i < list.length; i++) {
      list[i] = rnd.nextDouble() * 2 - 1;
    }
    return list;
  }();

  Size? size;
  final Path band = Path();
  final Path core = Path();

  void resolve(Size s) {
    if (size == s) return;
    size = s;
    band.reset();
    core.reset();
    final thickness = (s.height * 0.26).clamp(4.0, 14.0);
    final mid = s.height - thickness * 0.75;
    final top = List<Offset>.filled(samples + 1, Offset.zero);
    final bottom = List<Offset>.filled(samples + 1, Offset.zero);
    for (var i = 0; i <= samples; i++) {
      final u = i / samples;
      final x = -2 + u * (s.width + 4);
      final taper = math.pow(math.sin(math.pi * (0.04 + u * 0.92)), 0.35).toDouble();
      final n0 = noise[(i % samples) * 2];
      final n1 = noise[(i % samples) * 2 + 1];
      final drift = math.sin(u * math.pi * 2.3) * thickness * 0.12;
      final half = thickness * 0.5 * taper * (0.85 + 0.15 * n0);
      top[i] = Offset(x, mid + drift - half + n1 * thickness * 0.08);
      bottom[i] = Offset(x, mid + drift + half + n0 * thickness * 0.08);
      if (i == 0) {
        core.moveTo(x, mid + drift);
      } else {
        core.lineTo(x, mid + drift + n1 * 0.4);
      }
    }
    band.moveTo(top[0].dx, top[0].dy);
    for (var i = 1; i <= samples; i++) {
      band.lineTo(top[i].dx, top[i].dy);
    }
    for (var i = samples; i >= 0; i--) {
      band.lineTo(bottom[i].dx, bottom[i].dy);
    }
    band.close();
  }
}

class _BrushPainter extends CustomPainter {
  _BrushPainter({required this.progress, required this.cache, required this.color})
    : _fill = Paint()..color = color.withValues(alpha: 0.32),
      _halo = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = color.withValues(alpha: 0.18),
      _core = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..color = color.withValues(alpha: 0.9),
      super(repaint: progress);

  final Animation<double> progress;
  final _BrushCache cache;
  final Color color;
  final Paint _fill;
  final Paint _halo;
  final Paint _core;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t <= 0 || size.isEmpty) return;
    cache.resolve(size);
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(-4, 0, (size.width + 8) * t, size.height + 4));
    canvas.drawPath(cache.band, _fill);
    canvas.drawPath(cache.core, _halo);
    canvas.drawPath(cache.core, _core);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BrushPainter old) => old.color != color || old.progress != progress;
}
