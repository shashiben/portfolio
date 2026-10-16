import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../app/theme/app_motion.dart';
import '../../app/tokens/color_tokens.dart';
import 'fx_common.dart';

/// Drives the full-screen transform flash. Use the global [transformController].
class TransformController extends ChangeNotifier {
  Ticker? _ticker;
  Completer<void>? _completer;
  VoidCallback? _atPeak;
  bool _peaked = false;
  double _progress = 0;

  bool get playing => _completer != null;

  /// 0..1 while playing, for painters.
  double get progress => _progress;

  bool get _reduceMotion => SchedulerBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;

  /// Runs the flash. Calls [atPeak] at the midpoint so the router can swap pages.
  Future<void> play({VoidCallback? atPeak}) {
    if (_reduceMotion) {
      atPeak?.call();
      return Future<void>.value();
    }
    if (_completer != null) {
      atPeak?.call();
      return _completer!.future;
    }
    _completer = Completer<void>();
    _atPeak = atPeak;
    _peaked = false;
    _progress = 0;
    (_ticker ??= Ticker(_tick, debugLabel: 'TransformController')).start();
    notifyListeners();
    return _completer!.future;
  }

  void _tick(Duration elapsed) {
    _progress = (elapsed.inMicroseconds / AppMotion.transform.inMicroseconds).clamp(0.0, 1.0);
    if (!_peaked && _progress >= 0.5) {
      _peaked = true;
      final cb = _atPeak;
      _atPeak = null;
      cb?.call();
    }
    if (_progress >= 1) {
      _ticker!.stop();
      _progress = 0;
      final completer = _completer!;
      _completer = null;
      notifyListeners();
      completer.complete();
      return;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }
}

final TransformController transformController = TransformController();

/// Full-screen, non-interactive overlay that renders [controller]'s flash. Place it on top of the app.
class TransformFlash extends StatelessWidget {
  const TransformFlash({super.key, this.controller});

  final TransformController? controller;

  @override
  Widget build(BuildContext context) {
    if (fxReduceMotion(context)) return const SizedBox.shrink();
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(size: Size.infinite, painter: _FlashPainter(controller ?? transformController)),
      ),
    );
  }
}

class _FlashPainter extends CustomPainter {
  _FlashPainter(this.controller) : super(repaint: controller);

  static const Color _green = ColorTokens.omniGreen;
  static const Color _void = ColorTokens.omniVoid;
  static const int _discs = 6;
  static const int _helices = 3;
  static const double _step = 12;

  final TransformController controller;
  final Paint _wash = Paint();
  final Paint _disc = Paint();
  final Paint _ring = Paint()..style = PaintingStyle.stroke;
  final Paint _strand = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;
  final Paint _rung = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  final Path _a = Path();
  final Path _b = Path();
  final Path _rungs = Path();

  @override
  void paint(Canvas canvas, Size size) {
    if (!controller.playing || size.isEmpty) return;
    final p = controller.progress;
    final o =
        0.85 * (p < 0.5 ? AppMotion.easeOut.transform(p / 0.5) : 1 - AppMotion.easeInOut.transform((p - 0.5) / 0.5));
    if (o <= 0.001) return;

    final center = size.center(Offset.zero);
    final maxR = math.sqrt(size.width * size.width + size.height * size.height) / 2;
    final e = AppMotion.easeOut.transform(p);

    _wash.color = _void.withValues(alpha: o * 0.7);
    canvas.drawRect(Offset.zero & size, _wash);

    _disc.color = _green.withValues(alpha: o * 0.12);
    for (var i = 1; i <= _discs; i++) {
      canvas.drawCircle(center, maxR * (0.15 + 0.85 * e) * i / _discs, _disc);
    }

    final ringR = maxR * e;
    _ring
      ..strokeWidth = 18
      ..color = _green.withValues(alpha: o * 0.15);
    canvas.drawCircle(center, ringR, _ring);
    _ring
      ..strokeWidth = 6
      ..color = _green.withValues(alpha: o * 0.4);
    canvas.drawCircle(center, ringR, _ring);
    _ring
      ..strokeWidth = 2
      ..color = _green.withValues(alpha: o);
    canvas.drawCircle(center, ringR, _ring);

    _strand.color = _green.withValues(alpha: o * 0.8);
    _rung.color = _green.withValues(alpha: o * 0.35);
    final amp = math.min(size.height * 0.06, 36.0);
    final freq = 2 * math.pi / math.max(size.width * 0.35, 160);
    for (var h = 0; h < _helices; h++) {
      final cy = size.height * (h + 1) / (_helices + 1);
      final phase = p * math.pi * 4 + h * 1.3;
      _a.reset();
      _b.reset();
      _rungs.reset();
      var i = 0;
      for (var x = 0.0; x <= size.width + _step; x += _step, i++) {
        final s = math.sin(x * freq + phase) * amp;
        if (i == 0) {
          _a.moveTo(x, cy + s);
          _b.moveTo(x, cy - s);
        } else {
          _a.lineTo(x, cy + s);
          _b.lineTo(x, cy - s);
        }
        if (i % 3 == 0) {
          _rungs
            ..moveTo(x, cy + s)
            ..lineTo(x, cy - s);
        }
      }
      canvas.drawPath(_a, _strand);
      canvas.drawPath(_b, _strand);
      canvas.drawPath(_rungs, _rung);
    }
  }

  @override
  bool shouldRepaint(covariant _FlashPainter old) => old.controller != controller;
}
