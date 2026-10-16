import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../app/tokens/color_tokens.dart';
import 'fx_common.dart';

/// Trailing green ring cursor for mouse users on web. Returns [child] unchanged elsewhere.
class OmniCursor extends StatelessWidget {
  const OmniCursor({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || fxReduceMotion(context)) return child;
    return _OmniCursor(child: child);
  }
}

class _OmniCursor extends StatefulWidget {
  const _OmniCursor({required this.child});

  final Widget child;

  @override
  State<_OmniCursor> createState() => _OmniCursorState();
}

class _CursorModel extends ChangeNotifier {
  // x, y, targetX, targetY, scale, targetScale, alpha, targetAlpha
  final Float32List s = Float32List(8)
    ..[4] = 1
    ..[5] = 1;

  void changed() => notifyListeners();
}

class _OmniCursorState extends State<_OmniCursor> with SingleTickerProviderStateMixin {
  final _CursorModel _model = _CursorModel();
  late final Ticker _ticker = createTicker(_tick);
  Duration _last = Duration.zero;

  void _wake() {
    if (_ticker.isActive) return;
    _last = Duration.zero;
    _ticker.start();
  }

  void _tick(Duration elapsed) {
    final dt = _last == Duration.zero ? 1 / 60 : (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    final s = _model.s;
    final kPos = 1 - math.exp(-dt * 18);
    final kOther = 1 - math.exp(-dt * 12);
    s[0] += (s[2] - s[0]) * kPos;
    s[1] += (s[3] - s[1]) * kPos;
    s[4] += (s[5] - s[4]) * kOther;
    s[6] += (s[7] - s[6]) * kOther;
    _model.changed();
    final settled =
        (s[2] - s[0]).abs() < 0.1 &&
        (s[3] - s[1]).abs() < 0.1 &&
        (s[5] - s[4]).abs() < 0.002 &&
        (s[7] - s[6]).abs() < 0.002;
    if (settled) _ticker.stop();
  }

  bool _overClickable(Offset global) {
    final result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(result, global, View.of(context).viewId);
    for (final entry in result.path) {
      final target = entry.target;
      if (target is RenderMouseRegion && target.cursor == SystemMouseCursors.click) return true;
    }
    return false;
  }

  void _onMove(PointerEvent e) {
    if (e.kind != PointerDeviceKind.mouse) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final local = box.globalToLocal(e.position);
    final s = _model.s;
    if (s[7] == 0 && s[6] < 0.01) {
      s[0] = local.dx;
      s[1] = local.dy;
    }
    s[2] = local.dx;
    s[3] = local.dy;
    s[5] = _overClickable(e.position) ? 1.8 : 1;
    s[7] = 1;
    _wake();
  }

  void _hide() {
    _model.s[7] = 0;
    _wake();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerHover: _onMove,
      onPointerMove: _onMove,
      onPointerDown: (e) {
        if (e.kind != PointerDeviceKind.mouse) _hide();
      },
      child: Stack(
        alignment: Alignment.topLeft,
        fit: StackFit.passthrough,
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(child: CustomPaint(painter: _CursorPainter(_model))),
            ),
          ),
          Positioned.fill(
            child: MouseRegion(
              opaque: false,
              hitTestBehavior: HitTestBehavior.translucent,
              cursor: SystemMouseCursors.none,
              onExit: (_) => _hide(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CursorPainter extends CustomPainter {
  _CursorPainter(this.model) : super(repaint: model);

  static const double _radius = 12;
  static const Color _color = ColorTokens.omniGreen;

  final _CursorModel model;
  final Paint _halo = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6;
  final Paint _ring = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;
  final Paint _dot = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final s = model.s;
    final a = s[6];
    if (a <= 0.01) return;
    final center = Offset(s[0], s[1]);
    final r = _radius * s[4];
    _halo.color = _color.withValues(alpha: 0.14 * a);
    _ring.color = _color.withValues(alpha: 0.9 * a);
    _dot.color = _color.withValues(alpha: a);
    canvas.drawCircle(center, r, _halo);
    canvas.drawCircle(center, r, _ring);
    canvas.drawCircle(Offset(s[2], s[3]), 2.5, _dot);
  }

  @override
  bool shouldRepaint(covariant _CursorPainter old) => old.model != model;
}
