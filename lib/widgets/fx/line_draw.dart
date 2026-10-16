import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';
import '../../app/theme/app_theme_colors.dart';
import 'fx_common.dart';

/// Draws [pathBuilder]'s path progressively. Fills its parent's constraints, so give it a bounded size.
class LineDraw extends StatefulWidget {
  const LineDraw({
    super.key,
    required this.pathBuilder,
    this.color,
    this.strokeWidth = 2,
    this.duration,
    this.autoPlay = true,
    this.progress,
    this.loop = false,
  });

  final Path Function(Size size) pathBuilder;
  final Color? color;
  final double strokeWidth;
  final Duration? duration;
  final bool autoPlay;

  /// 0..1. When set, the caller drives the animation and autoplay is off.
  final double? progress;
  final bool loop;

  @override
  State<LineDraw> createState() => _LineDrawState();
}

class _LineDrawState extends State<LineDraw> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration ?? const Duration(milliseconds: 1200),
  );
  late final Animation<double> _curved = CurvedAnimation(parent: _controller, curve: AppMotion.easeInOut);
  late final ValueNotifier<double> _manual = ValueNotifier<double>(widget.progress ?? 0);
  final FxPathCache _cache = FxPathCache();
  bool _visible = false;

  ValueListenable<double> get _t => widget.progress != null ? _manual : _curved;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.autoPlay && fxReduceMotion(context)) _controller.value = 1;
  }

  @override
  void didUpdateWidget(covariant LineDraw oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != null) _manual.value = widget.progress!.clamp(0.0, 1.0);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration ?? const Duration(milliseconds: 1200);
    }
    if (!identical(widget.pathBuilder, oldWidget.pathBuilder)) _cache.invalidate();
    if (widget.loop != oldWidget.loop || widget.autoPlay != oldWidget.autoPlay) _sync();
  }

  void _sync() {
    if (widget.progress != null || !widget.autoPlay) {
      _controller.stop();
      return;
    }
    if (fxReduceMotion(context)) {
      _controller.value = 1;
      return;
    }
    if (!_visible) {
      if (widget.loop) _controller.stop();
      return;
    }
    if (widget.loop) {
      if (!_controller.isAnimating) _controller.repeat();
    } else if (_controller.value < 1 && !_controller.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _manual.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.appColors.accent;
    return FxVisibility(
      onShow: () {
        _visible = true;
        _sync();
      },
      onHide: () {
        _visible = false;
        _sync();
      },
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: LineDrawPainter(
            progress: _t,
            cache: _cache,
            pathBuilder: widget.pathBuilder,
            color: color,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

/// Caches a built path and its metrics per size.
class FxPathCache {
  Size? _size;
  Path? _path;
  List<ui.PathMetric> _metrics = const [];
  double _length = 0;

  List<ui.PathMetric> get metrics => _metrics;
  double get length => _length;
  Path? get path => _path;

  void invalidate() => _size = null;

  void resolve(Size size, Path Function(Size) builder) {
    if (_size == size && _path != null) return;
    _size = size;
    _path = builder(size);
    _metrics = _path!.computeMetrics().toList(growable: false);
    var total = 0.0;
    for (final m in _metrics) {
      total += m.length;
    }
    _length = total;
  }
}

/// Paints the first `progress * length` of a path with a brighter leading tip.
class LineDrawPainter extends CustomPainter {
  LineDrawPainter({
    required this.progress,
    required this.cache,
    required this.pathBuilder,
    required this.color,
    required this.strokeWidth,
  }) : _line = Paint()
         ..style = PaintingStyle.stroke
         ..strokeCap = StrokeCap.round
         ..strokeJoin = StrokeJoin.round
         ..strokeWidth = strokeWidth
         ..color = color,
       _halo = Paint()
         ..style = PaintingStyle.stroke
         ..strokeCap = StrokeCap.round
         ..strokeWidth = strokeWidth * 3.5
         ..color = color.withValues(alpha: 0.18),
       _tip = Paint()
         ..style = PaintingStyle.stroke
         ..strokeCap = StrokeCap.round
         ..strokeWidth = strokeWidth * 1.6
         ..color = Color.lerp(color, Colors.white, 0.65)!,
       super(repaint: progress);

  final ValueListenable<double> progress;
  final FxPathCache cache;
  final Path Function(Size size) pathBuilder;
  final Color color;
  final double strokeWidth;

  final Paint _line;
  final Paint _halo;
  final Paint _tip;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    cache.resolve(size, pathBuilder);
    final t = progress.value.clamp(0.0, 1.0);
    if (t <= 0 || cache.length <= 0) return;

    final target = cache.length * t;
    final tipLen = (cache.length * 0.04).clamp(6.0, 28.0);
    var consumed = 0.0;
    for (final m in cache.metrics) {
      if (consumed >= target) break;
      final end = (target - consumed).clamp(0.0, m.length);
      canvas.drawPath(m.extractPath(0, end), _line);
      if (t < 1 && consumed + m.length >= target) {
        final tip = m.extractPath((end - tipLen).clamp(0.0, end), end);
        canvas.drawPath(tip, _halo);
        canvas.drawPath(tip, _tip);
      }
      consumed += m.length;
    }
  }

  @override
  bool shouldRepaint(covariant LineDrawPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      !identical(old.pathBuilder, pathBuilder);
}
