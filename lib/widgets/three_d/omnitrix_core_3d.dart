import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show PointMode;

import 'package:flutter/widgets.dart';

import '../../app/tokens/color_tokens.dart';
import 'engine.dart';
import 'quality.dart';

class OmnitrixCore3D extends StatefulWidget {
  const OmnitrixCore3D({super.key, this.size = 320, this.pointer, this.spinBoost = 0, this.spin});

  final double size;

  /// pointer is normalized -1..1 from center, or null. If null, widget tracks its own MouseRegion.
  final Offset? pointer;

  /// 0..1 extra spin speed (slam).
  final double spinBoost;

  /// Set to 1 (via a 0 then 1 pulse) to fire the transform surge and a spin kick.
  final ValueNotifier<double>? spin;

  @override
  State<OmnitrixCore3D> createState() => _OmnitrixCore3DState();
}

class _CoreScene {
  static const int maxMajor = 48;
  static const int sides = 6;
  static const int hourglassSegments = 16;
  static const int maxVerts = (maxMajor * sides * 2 + hourglassSegments) * 2;
  static const int dotCount = 4;
  static const int capVerts = 8;
  static const double capHx = 0.42;
  static const double capHz = 0.18;
  static const double capHy = 0.62;
  static final Int32List faceIndices = Int32List.fromList([0, 1, 2, 0, 2, 3, 4, 5, 6, 4, 6, 7]);

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
  final Float32List faceXyz = Float32List(capVerts * 3);
  final Float32List faceN = Float32List(capVerts * 3);
  final Float32List faceXy = Float32List(capVerts * 2);
  final Float64List faceDepth = Float64List(capVerts);
  final Float32List faceShade = Float32List(capVerts);
  final _Surge surge = _Surge();

  int lineVerts = 0;
  bool fill = true;
  double yaw = restYaw;
  double pitch = restPitch;
  double yawVel = 0;
  double pitchVel = 0;
  double roll = 0;
  double orbit = 0;
  double time = 0;
  double fov = _CorePainter.baseFov;

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
    _buildCaps();
  }

  void _buildCaps() {
    const corners = [
      [capHx, capHz],
      [capHx, -capHz],
      [-capHx, -capHz],
      [-capHx, capHz],
    ];
    for (final sign in const [1.0, -1.0]) {
      final base = sign > 0 ? 0 : 4;
      for (var c = 0; c < 4; c++) {
        putVec(faceXyz, base + c, corners[c][0], capHy * sign, corners[c][1]);
        putVec(faceN, base + c, 0, sign, 0);
      }
    }
  }

  void placeDots() {
    const r = 1.3;
    for (var k = 0; k < dotCount; k++) {
      final a = orbit + math.pi / 4 + k * math.pi / 2;
      putVec(dotXyz, k, r * math.cos(a), r * math.sin(a), 0);
    }
  }
}

class _Surge {
  static const int count = 28;

  final Float32List xyz = Float32List(count * 3);
  final Float32List xy = Float32List(count * 2);
  final Float64List depth = Float64List(count);
  final DepthBands points = DepthBands(
    mode: PointMode.points,
    color: ColorTokens.omniGreen,
    strokeWidth: 3.2,
    cap: StrokeCap.round,
    bands: 3,
    minAlpha: 0.25,
  );

  double life = 0;
  double age = 0;

  _Surge() {
    points.resize(count);
  }

  void burst() {
    life = 1;
    age = 0;
  }

  void tick(double dt) {
    if (life <= 0) return;
    age += dt;
    life = (life - dt * 1.7).clamp(0.0, 1.0);
    final rad = 0.2 + age * 2.6;
    for (var i = 0; i < count; i++) {
      final a = i / count * math.pi * 2 + age * 2.4;
      final lift = math.sin(i * 1.9) * 0.22 * age;
      putVec(xyz, i, rad * math.cos(a), lift, rad * math.sin(a));
    }
  }
}

class _OmnitrixCore3DState extends State<OmnitrixCore3D> with SingleTickerProviderStateMixin, SceneHost {
  late final _CoreScene _scene;
  Offset _hover = Offset.zero;
  double _boost = 0;

  @override
  void initState() {
    _scene = _CoreScene();
    super.initState();
    widget.spin?.addListener(_onSpin);
  }

  @override
  void didUpdateWidget(OmnitrixCore3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spin != widget.spin) {
      oldWidget.spin?.removeListener(_onSpin);
      widget.spin?.addListener(_onSpin);
    }
  }

  void _onSpin() {
    if (!gate.enableSpin) return;
    if ((widget.spin?.value ?? 0) >= 0.99) {
      _boost = 1;
      _scene.surge.burst();
    }
  }

  @override
  void onQualityChanged() {
    final s = _scene;
    s.build(gate.tier == QualityTier.high ? 48 : 24);
    s.lines.glow = gate.enableGlow;
    s.fill = gate.enableFill;
    s.fov = _CorePainter.baseFov;
    if (!gate.enableSpin) {
      _boost = 0;
      s
        ..yaw = _CoreScene.restYaw
        ..pitch = _CoreScene.restPitch
        ..yawVel = 0
        ..pitchVel = 0
        ..roll = 0
        ..surge.life = 0;
    }
  }

  @override
  void onSceneTick(double dt) {
    final p = widget.pointer ?? _hover;
    const omega = 9.0;
    final s = _scene;
    final yaw = springTo(s.yaw, s.yawVel, _CoreScene.restYaw + p.dx * 0.6, omega, dt);
    final pitch = springTo(s.pitch, s.pitchVel, _CoreScene.restPitch + p.dy * 0.45, omega, dt);
    s
      ..yaw = yaw.$1
      ..yawVel = yaw.$2
      ..pitch = pitch.$1
      ..pitchVel = pitch.$2;
    _boost = math.max(0.0, _boost - dt * 1.8);
    final kick = math.max(_boost, widget.spinBoost.clamp(0.0, 1.0));
    s.roll += dt * (0.35 + kick * 6);
    s.orbit += dt * 0.8;
    s.time += dt;
    s.fov = _CorePainter.baseFov * (1 + 0.028 * math.sin(s.time * math.pi * 2 / 1.8));
    s.placeDots();
    s.surge.tick(dt);
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

  @override
  void dispose() {
    widget.spin?.removeListener(_onSpin);
    super.dispose();
  }
}

class _CorePainter extends ScenePainter {
  _CorePainter(this.scene, Listenable repaint) : super(repaint: repaint);

  final _CoreScene scene;
  static const double baseFov = 2.8;
  static final Paint _surgeLayer = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final s = scene;
    if (s.fill) {
      projectLines(s.faceXyz, _CoreScene.capVerts, s.faceXy, s.faceDepth, s.yaw, s.pitch, size, s.fov, roll: s.roll);
      lambertShade(s.faceN, _CoreScene.capVerts, s.faceShade, s.yaw, s.pitch, roll: s.roll);
      drawFaces(canvas, s.faceXy, s.faceShade, _CoreScene.faceIndices, ColorTokens.omniGreen.withValues(alpha: 0.28));
    }
    projectLines(s.lineXyz, s.lineVerts, s.lineXy, s.lineDepth, s.yaw, s.pitch, size, s.fov, roll: s.roll);
    s.lines.draw(canvas, s.lineXy, s.lineDepth);
    projectLines(s.dotXyz, _CoreScene.dotCount, s.dotXy, s.dotDepth, s.yaw, s.pitch, size, s.fov, roll: s.roll);
    s.dots.draw(canvas, s.dotXy, s.dotDepth);
    if (s.surge.life > 0.02) {
      projectLines(s.surge.xyz, _Surge.count, s.surge.xy, s.surge.depth, s.yaw, s.pitch, size, s.fov, roll: s.roll);
      _surgeLayer.color = Color.fromRGBO(255, 255, 255, s.surge.life);
      canvas.saveLayer(Offset.zero & size, _surgeLayer);
      s.surge.points.draw(canvas, s.surge.xy, s.surge.depth);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_CorePainter oldDelegate) => oldDelegate.scene != scene;
}
