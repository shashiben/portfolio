import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_theme_colors.dart';
import 'fx_common.dart';

class EnergyBackground extends StatelessWidget {
  const EnergyBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reduce = fxReduceMotion(context);
    final width = MediaQuery.sizeOf(context).width;
    final frozen = reduce || width < 800 || defaultTargetPlatform == TargetPlatform.iOS;
    return _EnergyBackground(
      reduceMotion: frozen,
      particleCount: frozen ? 0 : 40,
      accent: context.appColors.accent,
      line: context.appColors.line,
      child: child,
    );
  }
}

class _EnergyBackground extends StatefulWidget {
  const _EnergyBackground({
    required this.child,
    required this.reduceMotion,
    required this.particleCount,
    required this.accent,
    required this.line,
  });

  final Widget child;
  final bool reduceMotion;
  final int particleCount;
  final Color accent;
  final Color line;

  @override
  State<_EnergyBackground> createState() => _EnergyBackgroundState();
}

class _EnergyBackgroundState extends State<_EnergyBackground> with SingleTickerProviderStateMixin {
  static const int _seedStride = 5;

  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 24));
  final ValueNotifier<Offset?> _pointer = ValueNotifier<Offset?>(null);
  late Float32List _seeds;
  late Float32List _points;
  late Listenable _repaint;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _allocate();
    _repaint = Listenable.merge([_controller, _pointer]);
    _syncTicker();
  }

  void _allocate() {
    final n = widget.particleCount;
    final rnd = math.Random(7);
    _seeds = Float32List(n * _seedStride);
    _points = Float32List(n * 2);
    for (var i = 0; i < n; i++) {
      final o = i * _seedStride;
      _seeds[o] = rnd.nextDouble();
      _seeds[o + 1] = rnd.nextDouble();
      _seeds[o + 2] = (1 + rnd.nextInt(3)).toDouble();
      _seeds[o + 3] = (1 + rnd.nextInt(2)).toDouble();
      _seeds[o + 4] = rnd.nextDouble();
    }
  }

  void _syncTicker() {
    if (widget.reduceMotion || !_visible) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _EnergyBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.particleCount != widget.particleCount) _allocate();
    if (oldWidget.reduceMotion != widget.reduceMotion) _syncTicker();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FxVisibility(
      threshold: 0,
      onShow: () {
        _visible = true;
        _syncTicker();
      },
      onHide: () {
        _visible = false;
        _syncTicker();
      },
      child: MouseRegion(
        opaque: false,
        hitTestBehavior: HitTestBehavior.translucent,
        onHover: (e) => _pointer.value = e.localPosition,
        onExit: (_) => _pointer.value = null,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _EnergyPainter(
                      repaint: _repaint,
                      time: _controller,
                      pointer: _pointer,
                      seeds: _seeds,
                      points: _points,
                      accent: widget.accent,
                      line: widget.line,
                    ),
                  ),
                ),
              ),
            ),
            widget.child,
          ],
        ),
      ),
    );
  }
}

class _EnergyPainter extends CustomPainter {
  _EnergyPainter({
    required Listenable repaint,
    required this.time,
    required this.pointer,
    required this.seeds,
    required this.points,
    required this.accent,
    required this.line,
  }) : _gridPaint = Paint()
         ..style = PaintingStyle.stroke
         ..strokeWidth = 1
         ..color = line.withValues(alpha: 0.55),
       _glowPaint = Paint()
         ..strokeCap = StrokeCap.round
         ..strokeWidth = 7
         ..color = accent.withValues(alpha: 0.10),
       _corePaint = Paint()
         ..strokeCap = StrokeCap.round
         ..strokeWidth = 2.2
         ..color = accent.withValues(alpha: 0.75),
       _scanPaint = Paint()..color = accent.withValues(alpha: 0.035),
       _scanCorePaint = Paint()..color = accent.withValues(alpha: 0.07),
       _spotPaint = Paint()..color = accent.withValues(alpha: 0.018),
       super(repaint: repaint);

  static const double _hexR = 28;
  static final double _hexW = math.sqrt(3) * _hexR;
  static const int _spotRings = 8;
  static const double _spotRadius = 340;

  final Animation<double> time;
  final ValueNotifier<Offset?> pointer;
  final Float32List seeds;
  final Float32List points;
  final Color accent;
  final Color line;

  final Paint _gridPaint;
  final Paint _glowPaint;
  final Paint _corePaint;
  final Paint _scanPaint;
  final Paint _scanCorePaint;
  final Paint _spotPaint;

  static Path? _gridPath;
  static Size? _gridSize;

  static Path _grid(Size size) {
    if (_gridPath != null && _gridSize == size) return _gridPath!;
    final path = Path();
    final cols = (size.width / _hexW).ceil() + 3;
    final rows = (size.height / (_hexR * 1.5)).ceil() + 4;
    final verts = List<Offset>.filled(6, Offset.zero);
    for (var j = -2; j < rows; j++) {
      final cy = j * _hexR * 1.5;
      final shift = j.isOdd ? _hexW / 2 : 0.0;
      for (var i = -2; i < cols; i++) {
        final cx = i * _hexW + shift;
        for (var k = 0; k < 6; k++) {
          final a = (60 * k - 90) * math.pi / 180;
          verts[k] = Offset(cx + _hexR * math.cos(a), cy + _hexR * math.sin(a));
        }
        path.addPolygon(verts, true);
      }
    }
    _gridPath = path;
    _gridSize = size;
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final t = time.value;

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate(-t * _hexW, -t * _hexR * 3);
    canvas.drawPath(_grid(size), _gridPaint);
    canvas.restore();

    final p = pointer.value;
    if (p != null) {
      for (var i = _spotRings; i > 0; i--) {
        canvas.drawCircle(p, _spotRadius * i / _spotRings, _spotPaint);
      }
    }

    final n = points.length ~/ 2;
    if (n > 0) {
      for (var i = 0; i < n; i++) {
        final o = i * 5;
        final y = (seeds[o + 1] - t * seeds[o + 2]) % 1.0;
        final x = seeds[o] + 0.015 * math.sin(2 * math.pi * (t * seeds[o + 3] + seeds[o + 4]));
        points[i * 2] = x * size.width;
        points[i * 2 + 1] = y * size.height;
      }
      canvas.drawRawPoints(ui.PointMode.points, points, _glowPaint);
      canvas.drawRawPoints(ui.PointMode.points, points, _corePaint);

      final sy = ((t * 4) % 1.0) * size.height;
      canvas.drawRect(Rect.fromLTWH(0, sy - 6, size.width, 12), _scanPaint);
      canvas.drawRect(Rect.fromLTWH(0, sy - 0.5, size.width, 1), _scanCorePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyPainter old) =>
      old.seeds != seeds || old.accent != accent || old.line != line || old.time != time;
}
