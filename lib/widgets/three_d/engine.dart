import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show BlendMode, BlurStyle, MaskFilter, PointMode, VertexMode, Vertices;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'package:visibility_detector/visibility_detector.dart';

import 'quality.dart';

class Vec3 {
  const Vec3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  /// Yaw around Y, then pitch around X.
  Vec3 rotated(double yaw, double pitch) {
    final cy = math.cos(yaw), sy = math.sin(yaw);
    final x1 = x * cy + z * sy;
    final z1 = -x * sy + z * cy;
    final cp = math.cos(pitch), sp = math.sin(pitch);
    return Vec3(x1, y * cp - z1 * sp, y * sp + z1 * cp);
  }
}

/// Base painter with an allocation-free perspective projection.
abstract class ScenePainter extends CustomPainter {
  ScenePainter({super.repaint});

  static const double cameraZ = 4;

  /// Projects [count] xyz vertices into screen-space [outXy] and camera-space
  /// [outDepth] (larger = farther). Rotation order: roll (Z), yaw (Y), pitch (X).
  /// [fov] is the focal length in model units; screen unit = half the shortest side.
  void projectLines(
    Float32List xyz,
    int count,
    Float32List outXy,
    Float64List outDepth,
    double yaw,
    double pitch,
    Size size,
    double fov, {
    double roll = 0,
  }) {
    final cr = math.cos(roll), sr = math.sin(roll);
    final cy = math.cos(yaw), sy = math.sin(yaw);
    final cp = math.cos(pitch), sp = math.sin(pitch);
    final cx = size.width / 2, cyScreen = size.height / 2;
    final unit = size.shortestSide / 2;
    for (var i = 0; i < count; i++) {
      final b = i * 3;
      final x = xyz[b], y = xyz[b + 1], z = xyz[b + 2];
      final x0 = x * cr - y * sr;
      final y0 = x * sr + y * cr;
      final x1 = x0 * cy + z * sy;
      final z1 = -x0 * sy + z * cy;
      final y2 = y0 * cp - z1 * sp;
      final z2 = y0 * sp + z1 * cp;
      final depth = z2 + cameraZ;
      final scale = fov / depth * unit;
      outXy[i * 2] = cx + x1 * scale;
      outXy[i * 2 + 1] = cyScreen - y2 * scale;
      outDepth[i] = depth;
    }
  }
}

/// Depth-sorts projected points or segments (far first) into fixed rank bands,
/// each drawn with one cached Paint whose alpha fades with distance.
class DepthBands {
  DepthBands({
    required this.mode,
    required Color color,
    double strokeWidth = 1,
    StrokeCap cap = StrokeCap.butt,
    this.bands = 6,
    double minAlpha = 0.15,
    this.glowSigma = 5,
  }) : assert(mode != PointMode.polygon),
       _strokeWidth = strokeWidth,
       _cap = cap,
       _paints = List<Paint>.generate(
         bands,
         (b) => Paint()
           ..isAntiAlias = true
           ..strokeWidth = strokeWidth
           ..strokeCap = cap
           ..color = color.withValues(alpha: color.a * (minAlpha + (1 - minAlpha) * (b + 1) / bands)),
         growable: false,
       ),
       _starts = Int32List(bands + 1);

  final PointMode mode;
  final int bands;
  final double glowSigma;
  final double _strokeWidth;
  final StrokeCap _cap;
  final List<Paint> _paints;
  final Int32List _starts;
  List<Paint>? _glowPaints;
  bool _glow = false;

  bool get glow => _glow;

  set glow(bool value) {
    if (value == _glow) return;
    _glow = value;
    if (value) {
      _glowPaints ??= List<Paint>.generate(
        bands,
        (b) => Paint()
          ..isAntiAlias = true
          ..strokeWidth = _strokeWidth * 3
          ..strokeCap = _cap
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSigma)
          ..color = _paints[b].color.withValues(alpha: (_paints[b].color.a * 0.55).clamp(0.0, 1.0)),
        growable: false,
      );
    }
  }

  int _items = 0;
  Int32List _order = Int32List(0);
  Float64List _keys = Float64List(0);
  List<Float32List> _buffers = const [];

  int get _floatsPerItem => mode == PointMode.lines ? 4 : 2;

  /// Allocates band buffers; call outside paint when the item count changes.
  void resize(int items) {
    if (items == _items) return;
    _items = items;
    _order = Int32List(items);
    for (var i = 0; i < items; i++) {
      _order[i] = i;
    }
    _keys = Float64List(items);
    for (var b = 0; b <= bands; b++) {
      _starts[b] = b * items ~/ bands;
    }
    _buffers = List<Float32List>.generate(
      bands,
      (b) => Float32List((_starts[b + 1] - _starts[b]) * _floatsPerItem),
      growable: false,
    );
  }

  /// [xy]/[depth] are per-vertex; for lines, item i uses vertices 2i and 2i+1.
  void draw(Canvas canvas, Float32List xy, Float64List depth) {
    final n = _items;
    if (n == 0) return;
    final lines = mode == PointMode.lines;
    final keys = _keys, order = _order;
    for (var i = 0; i < n; i++) {
      keys[i] = lines ? depth[i * 2] + depth[i * 2 + 1] : depth[i];
    }
    // Insertion sort: order is nearly sorted from the previous frame.
    for (var i = 1; i < n; i++) {
      final idx = order[i];
      final k = keys[idx];
      var j = i - 1;
      while (j >= 0 && keys[order[j]] < k) {
        order[j + 1] = order[j];
        j--;
      }
      order[j + 1] = idx;
    }
    var r = 0;
    for (var b = 0; b < bands; b++) {
      final buf = _buffers[b];
      final end = _starts[b + 1];
      var o = 0;
      for (; r < end; r++) {
        final idx = order[r];
        if (lines) {
          final s = idx * 4;
          buf[o] = xy[s];
          buf[o + 1] = xy[s + 1];
          buf[o + 2] = xy[s + 2];
          buf[o + 3] = xy[s + 3];
          o += 4;
        } else {
          final s = idx * 2;
          buf[o] = xy[s];
          buf[o + 1] = xy[s + 1];
          o += 2;
        }
      }
      if (buf.isEmpty) continue;
      if (_glow) canvas.drawRawPoints(mode, buf, _glowPaints![b]);
      canvas.drawRawPoints(mode, buf, _paints[b]);
    }
  }
}

/// Ticker that only runs while enabled and visible; doubles as the repaint
/// listenable for the scene's painter.
class SceneDriver extends ChangeNotifier {
  SceneDriver(TickerProvider vsync, this.onTick) {
    _ticker = vsync.createTicker(_tick);
  }

  final void Function(double dt) onTick;
  late final Ticker _ticker;
  int _lastUs = 0;
  bool _visible = true;
  bool _enabled = false;

  set visible(bool value) {
    if (value == _visible) return;
    _visible = value;
    _sync();
  }

  set enabled(bool value) {
    if (value == _enabled) return;
    _enabled = value;
    _sync();
  }

  void repaint() => notifyListeners();

  void _sync() {
    final run = _visible && _enabled;
    if (run && !_ticker.isActive) {
      _lastUs = 0;
      _ticker.start();
    } else if (!run && _ticker.isActive) {
      _ticker.stop();
    }
  }

  void _tick(Duration elapsed) {
    final us = elapsed.inMicroseconds;
    final dt = ((us - _lastUs) / 1e6).clamp(0.0, 0.1);
    _lastUs = us;
    onTick(dt);
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

/// Wires a scene state to [QualityGate], a [SceneDriver] and visibility.
mixin SceneHost<T extends StatefulWidget> on SingleTickerProviderStateMixin<T> {
  late final SceneDriver driver;
  final Key _visibilityKey = UniqueKey();
  bool _configured = false;

  QualityGate get gate => QualityGate.instance;

  /// Rebuild geometry for the current tier. Never called from paint.
  void onQualityChanged();

  void onSceneTick(double dt);

  @override
  void initState() {
    super.initState();
    driver = SceneDriver(this, onSceneTick);
    gate.addListener(_handleQuality);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gate.attach(context);
    if (!_configured) {
      _configured = true;
      _handleQuality();
    }
  }

  void _handleQuality() {
    onQualityChanged();
    driver.enabled = gate.enableSpin;
    driver.repaint();
  }

  Widget wrapScene(Widget child) => VisibilityDetector(
    key: _visibilityKey,
    onVisibilityChanged: (info) {
      if (mounted) driver.visible = info.visibleFraction > 0;
    },
    child: RepaintBoundary(child: child),
  );

  @override
  void dispose() {
    gate.removeListener(_handleQuality);
    driver.dispose();
    super.dispose();
  }
}

void putVec(Float32List buf, int vertex, double x, double y, double z) {
  final b = vertex * 3;
  buf[b] = x;
  buf[b + 1] = y;
  buf[b + 2] = z;
}

/// Frame-rate independent exponential smoothing. [rate] is in 1/seconds.
double damp(double current, double target, double rate, double dt) {
  final k = 1 - math.exp(-rate * dt);
  return current + (target - current) * k;
}

/// Semi-implicit critically damped spring. Returns the next position and velocity.
(double, double) springTo(double pos, double vel, double target, double omega, double dt) {
  final accel = omega * omega * (target - pos) - 2 * omega * vel;
  final nextVel = vel + accel * dt;
  return (pos + nextVel * dt, nextVel);
}

/// Lambert shade (0..1) of model-space [normals] after the same rotation as [ScenePainter.projectLines].
void lambertShade(Float32List normals, int count, Float32List out, double yaw, double pitch, {double roll = 0}) {
  const lx = -0.35, ly = 0.72, lz = 0.6;
  final len = math.sqrt(lx * lx + ly * ly + lz * lz);
  final nxL = lx / len, nyL = ly / len, nzL = lz / len;
  final cr = math.cos(roll), sr = math.sin(roll);
  final cy = math.cos(yaw), sy = math.sin(yaw);
  final cp = math.cos(pitch), sp = math.sin(pitch);
  for (var i = 0; i < count; i++) {
    final b = i * 3;
    final x = normals[b], y = normals[b + 1], z = normals[b + 2];
    final x0 = x * cr - y * sr;
    final y0 = x * sr + y * cr;
    final x1 = x0 * cy + z * sy;
    final z1 = -x0 * sy + z * cy;
    final y2 = y0 * cp - z1 * sp;
    final z2 = y0 * sp + z1 * cp;
    out[i] = (x1 * nxL + y2 * nyL + z2 * nzL).clamp(0.0, 1.0);
  }
}

/// Translucent triangles. [indices] are triples into [xy] / [shade].
void drawFaces(Canvas canvas, Float32List xy, Float32List shade, Int32List indices, Color color) {
  final n = indices.length;
  if (n < 3) return;
  final positions = Float32List(n * 2);
  final colors = Int32List(n);
  final r = (color.r * 255).round();
  final g = (color.g * 255).round();
  final b = (color.b * 255).round();
  final baseA = color.a;
  for (var i = 0; i < n; i++) {
    final vi = indices[i];
    positions[i * 2] = xy[vi * 2];
    positions[i * 2 + 1] = xy[vi * 2 + 1];
    final s = shade[vi].clamp(0.0, 1.0);
    final a = (baseA * (0.35 + 0.65 * s) * 255).round().clamp(0, 255);
    colors[i] = (a << 24) | (r << 16) | (g << 8) | b;
  }
  canvas.drawVertices(
    Vertices.raw(VertexMode.triangles, positions, colors: colors),
    BlendMode.srcOver,
    Paint()..color = const Color(0xFFFFFFFF),
  );
}
