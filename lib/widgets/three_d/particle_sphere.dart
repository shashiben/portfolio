import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show PointMode;

import 'package:flutter/widgets.dart';

import '../../app/tokens/color_tokens.dart';

import 'engine.dart';

class ParticleSphere extends StatefulWidget {
  const ParticleSphere({super.key, this.size = 280, this.morph = 0});

  final double size;

  /// morph 0..1 reserved; for now distribute Fibonacci sphere points and slowly rotate. morph can shift a subset toward a flat diamond silhouette using a simple lerp (no image sampling required).
  final double morph;

  @override
  State<ParticleSphere> createState() => _ParticleSphereState();
}

class _SphereScene {
  static const int maxPoints = 600;
  static const int staticPoints = 160;

  final Float32List baseXyz = Float32List(maxPoints * 3);
  final Float32List targetXyz = Float32List(maxPoints * 3);
  final Float32List xyz = Float32List(maxPoints * 3);
  final Float32List xy = Float32List(maxPoints * 2);
  final Float64List depth = Float64List(maxPoints);

  final DepthBands points = DepthBands(
    mode: PointMode.points,
    color: ColorTokens.omniGreen,
    strokeWidth: 2,
    cap: StrokeCap.round,
    minAlpha: 0.12,
  );

  int count = 0;
  double yaw = 0.6;

  void build(int n, double morph) {
    const golden = 2.399963229728653; // pi * (3 - sqrt(5))
    for (var i = 0; i < n; i++) {
      final y = 1 - 2 * (i + 0.5) / n;
      final r = math.sqrt(math.max(0, 1 - y * y));
      final phi = i * golden;
      final x = math.cos(phi) * r, z = math.sin(phi) * r;
      putVec(baseXyz, i, x, y, z);
      if (i.isEven) {
        final k = x.abs() / 0.7 + y.abs();
        if (k < 1e-6) {
          putVec(targetXyz, i, 0, 0, 0);
        } else {
          putVec(targetXyz, i, x / k, y / k, 0);
        }
      } else {
        putVec(targetXyz, i, x, y, z);
      }
    }
    count = n;
    points.resize(n);
    blend(morph);
  }

  void blend(double morph) {
    final t = morph.clamp(0.0, 1.0);
    for (var i = 0, end = count * 3; i < end; i++) {
      xyz[i] = baseXyz[i] + (targetXyz[i] - baseXyz[i]) * t;
    }
  }
}

class _ParticleSphereState extends State<ParticleSphere> with SingleTickerProviderStateMixin, SceneHost {
  late final _SphereScene _scene;

  @override
  void initState() {
    _scene = _SphereScene();
    super.initState();
  }

  @override
  void didUpdateWidget(ParticleSphere oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.morph != widget.morph) {
      _scene.blend(widget.morph);
      driver.repaint();
    }
  }

  @override
  void onQualityChanged() {
    final budget = gate.particleBudget;
    _scene.build(budget > 0 ? math.min(_SphereScene.maxPoints, budget) : _SphereScene.staticPoints, widget.morph);
  }

  @override
  void onSceneTick(double dt) => _scene.yaw += dt * 0.25;

  @override
  Widget build(BuildContext context) => wrapScene(
    SizedBox.square(
      dimension: widget.size,
      child: CustomPaint(painter: _SpherePainter(_scene, driver)),
    ),
  );
}

class _SpherePainter extends ScenePainter {
  _SpherePainter(this.scene, Listenable repaint) : super(repaint: repaint);

  final _SphereScene scene;
  static const double _fov = 3.0;
  static const double _pitch = 0.3;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scene;
    projectLines(s.xyz, s.count, s.xy, s.depth, s.yaw, _pitch, size, _fov);
    s.points.draw(canvas, s.xy, s.depth);
  }

  @override
  bool shouldRepaint(_SpherePainter oldDelegate) => oldDelegate.scene != scene;
}
