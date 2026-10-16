import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show PointMode;

import 'package:flutter/widgets.dart';

import '../../app/tokens/color_tokens.dart';

import 'engine.dart';
import 'quality.dart';

class OmnitrixCore3D extends StatefulWidget {
  const OmnitrixCore3D({super.key, this.size = 320, this.pointer, this.spinBoost = 0});

  final double size;

  /// pointer is normalized -1..1 from center, or null. If null, widget tracks its own MouseRegion.
  final Offset? pointer;

  /// 0..1 extra spin speed (slam).
  final double spinBoost;

  @override
  State<OmnitrixCore3D> createState() => _OmnitrixCore3DState();
}

class _CoreScene {
  static const int maxMajor = 48;
  static const int sides = 6;
  static const int hourglassSegments = 16;
  static const int maxVerts = (maxMajor * sides * 2 + hourglassSegments) * 2;
  static const int dotCount = 4;

  final Float32List lineXyz = Float32List(maxVerts * 3);
  final Float32List lineXy = Float32List(maxVerts * 2);
  final Float64List lineDepth = Float64List(maxVerts);
  final Float32List dotXyz = Float32List(dotCount * 3);
  final Float32List dotXy = Float32List(dotCount * 2);
  final Float64List dotDepth = Float64List(dotCount);

  final DepthBands lines = DepthBands(mode: PointMode.lines, color: ColorTokens.omniGreen, strokeWidth: 1.2);
  final DepthBands dots = DepthBands(
    mode: PointMode.points,
    color: ColorTokens.omniGreen,
    strokeWidth: 7,
    cap: StrokeCap.round,
    bands: 2,
    minAlpha: 0.45,
  );

  int lineVerts = 0;
  double yaw = restYaw;
  double pitch = restPitch;
  double roll = 0;
  double orbit = 0;

  static const double restYaw = -0.35;
  static const double restPitch = 0.25;

  void build(int major) {
    const ringR = 1.0, tubeR = 0.12;
    var v = 0;
    void torusPoint(int i, int j) {
      final u = i * 2 * math.pi / major;
      final w = j * 2 * math.pi / sides;
      final radial = ringR + tubeR * math.cos(w);
      putVec(lineXyz, v++, radial * math.cos(u), radial * math.sin(u), tubeR * math.sin(w));
    }

    for (var i = 0; i < major; i++) {
      for (var j = 0; j < sides; j++) {
        torusPoint(i, j);
        torusPoint(i + 1, j);
        torusPoint(i, j);
        torusPoint(i, j + 1);
      }
    }

    for (final sign in const [1.0, -1.0]) {
      const hx = 0.42, hz = 0.18, hy = 0.62;
      final y = hy * sign;
      const corners = [
        [hx, hz],
        [hx, -hz],
        [-hx, -hz],
        [-hx, hz],
      ];
      for (var c = 0; c < 4; c++) {
        final a = corners[c], b = corners[(c + 1) % 4];
        putVec(lineXyz, v++, 0, 0, 0);
        putVec(lineXyz, v++, a[0], y, a[1]);
        putVec(lineXyz, v++, a[0], y, a[1]);
        putVec(lineXyz, v++, b[0], y, b[1]);
      }
    }

    lineVerts = v;
    lines.resize(v ~/ 2);
    dots.resize(dotCount);
    placeDots();
  }

  void placeDots() {
    const r = 1.3;
    for (var k = 0; k < dotCount; k++) {
      final a = orbit + math.pi / 4 + k * math.pi / 2;
      putVec(dotXyz, k, r * math.cos(a), r * math.sin(a), 0);
    }
  }
}

class _OmnitrixCore3DState extends State<OmnitrixCore3D> with SingleTickerProviderStateMixin, SceneHost {
  late final _CoreScene _scene;
  Offset _hover = Offset.zero;

  @override
  void initState() {
    _scene = _CoreScene();
    super.initState();
  }

  @override
  void onQualityChanged() {
    _scene.build(gate.tier == QualityTier.high ? 48 : 24);
    if (!gate.enableSpin) {
      _scene
        ..yaw = _CoreScene.restYaw
        ..pitch = _CoreScene.restPitch
        ..roll = 0;
    }
  }

  @override
  void onSceneTick(double dt) {
    final p = widget.pointer ?? _hover;
    final k = math.min(1.0, dt * 6);
    final s = _scene;
    s.yaw += (_CoreScene.restYaw + p.dx * 0.6 - s.yaw) * k;
    s.pitch += (_CoreScene.restPitch + p.dy * 0.45 - s.pitch) * k;
    s.roll += dt * (0.35 + widget.spinBoost.clamp(0.0, 1.0) * 6);
    s.orbit += dt * 0.8;
    s.placeDots();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox.square(
      dimension: widget.size,
      child: CustomPaint(painter: _CorePainter(_scene, driver)),
    );
    if (widget.pointer == null) {
      child = MouseRegion(
        onHover: (e) {
          final half = widget.size / 2;
          _hover = Offset(
            ((e.localPosition.dx - half) / half).clamp(-1.0, 1.0),
            ((e.localPosition.dy - half) / half).clamp(-1.0, 1.0),
          );
        },
        onExit: (_) => _hover = Offset.zero,
        child: child,
      );
    }
    return wrapScene(child);
  }
}

class _CorePainter extends ScenePainter {
  _CorePainter(this.scene, Listenable repaint) : super(repaint: repaint);

  final _CoreScene scene;
  static const double _fov = 2.8;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scene;
    projectLines(s.lineXyz, s.lineVerts, s.lineXy, s.lineDepth, s.yaw, s.pitch, size, _fov, roll: s.roll);
    s.lines.draw(canvas, s.lineXy, s.lineDepth);
    projectLines(s.dotXyz, _CoreScene.dotCount, s.dotXy, s.dotDepth, s.yaw, s.pitch, size, _fov, roll: s.roll);
    s.dots.draw(canvas, s.dotXy, s.dotDepth);
  }

  @override
  bool shouldRepaint(_CorePainter oldDelegate) => oldDelegate.scene != scene;
}
