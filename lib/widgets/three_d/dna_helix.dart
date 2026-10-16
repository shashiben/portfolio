import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show PointMode;

import 'package:flutter/widgets.dart';

import '../../app/tokens/color_tokens.dart';

import 'engine.dart';

class DnaHelix extends StatefulWidget {
  const DnaHelix({super.key, this.size = 180});

  final double size;

  @override
  State<DnaHelix> createState() => _DnaHelixState();
}

class _HelixScene {
  static const int maxPerStrand = 100;
  static const int staticPerStrand = 40;
  static const int rungs = 12;
  static const double radius = 0.38;
  static const double turns = 2;

  final Float32List pointXyz = Float32List(maxPerStrand * 2 * 3);
  final Float32List pointXy = Float32List(maxPerStrand * 2 * 2);
  final Float64List pointDepth = Float64List(maxPerStrand * 2);
  final Float32List rungXyz = Float32List(rungs * 2 * 3);
  final Float32List rungXy = Float32List(rungs * 2 * 2);
  final Float64List rungDepth = Float64List(rungs * 2);

  final DepthBands points = DepthBands(
    mode: PointMode.points,
    color: ColorTokens.omniGreen,
    strokeWidth: 2.5,
    cap: StrokeCap.round,
    minAlpha: 0.12,
  );
  final DepthBands rungLines = DepthBands(mode: PointMode.lines, color: ColorTokens.omniGreen, bands: 3, minAlpha: 0.1);

  int pointCount = 0;
  double yaw = 0.4;

  static double _angle(double s) => s * 2 * math.pi * turns;

  void build(int perStrand) {
    var v = 0;
    for (var strand = 0; strand < 2; strand++) {
      final phase = strand * math.pi;
      for (var i = 0; i < perStrand; i++) {
        final s = i / (perStrand - 1);
        final a = _angle(s) + phase;
        putVec(pointXyz, v++, radius * math.cos(a), s * 2 - 1, radius * math.sin(a));
      }
    }
    pointCount = v;
    points.resize(v);

    for (var r = 0; r < rungs; r++) {
      final s = (r + 0.5) / rungs;
      final a = _angle(s);
      final y = s * 2 - 1;
      putVec(rungXyz, r * 2, radius * math.cos(a), y, radius * math.sin(a));
      putVec(rungXyz, r * 2 + 1, -radius * math.cos(a), y, -radius * math.sin(a));
    }
    rungLines.resize(rungs);
  }
}

class _DnaHelixState extends State<DnaHelix> with SingleTickerProviderStateMixin, SceneHost {
  late final _HelixScene _scene;

  @override
  void initState() {
    _scene = _HelixScene();
    super.initState();
  }

  @override
  void onQualityChanged() {
    final budget = gate.particleBudget;
    _scene.build(budget > 0 ? math.min(_HelixScene.maxPerStrand, budget ~/ 6) : _HelixScene.staticPerStrand);
  }

  @override
  void onSceneTick(double dt) => _scene.yaw += dt * 0.6;

  @override
  Widget build(BuildContext context) => wrapScene(
    SizedBox.square(
      dimension: widget.size,
      child: CustomPaint(painter: _HelixPainter(_scene, driver)),
    ),
  );
}

class _HelixPainter extends ScenePainter {
  _HelixPainter(this.scene, Listenable repaint) : super(repaint: repaint);

  final _HelixScene scene;
  static const double _fov = 3.2;
  static const double _pitch = 0.15;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scene;
    projectLines(s.rungXyz, _HelixScene.rungs * 2, s.rungXy, s.rungDepth, s.yaw, _pitch, size, _fov);
    s.rungLines.draw(canvas, s.rungXy, s.rungDepth);
    projectLines(s.pointXyz, s.pointCount, s.pointXy, s.pointDepth, s.yaw, _pitch, size, _fov);
    s.points.draw(canvas, s.pointXy, s.pointDepth);
  }

  @override
  bool shouldRepaint(_HelixPainter oldDelegate) => oldDelegate.scene != scene;
}
