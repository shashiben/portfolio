part of 'skill_galaxy.dart';

class _GalaxyPainter extends CustomPainter {
  _GalaxyPainter({
    required this.yaw,
    required this.pitch,
    required this.px,
    required this.py,
    required this.pz,
    required this.groupOfSkill,
    required this.selected,
    required this.group,
    required this.radius,
    required this.accent,
    required this.line,
  });

  final double yaw;
  final double pitch;
  final Float64List px;
  final Float64List py;
  final Float64List pz;
  final List<String> groupOfSkill;
  final int selected;
  final String? group;
  final double radius;
  final Color accent;
  final Color line;

  static const int _ringSegments = 72;

  Offset _screen(Offset c, double x, double y, double z) {
    final persp = 2.6 / (2.6 - z);
    return c + Offset(x * radius * persp, y * radius * persp);
  }

  Path _ring(Offset c, double Function(double) fx, double Function(double) fy, double Function(double) fz) {
    final cy = math.cos(yaw), sy = math.sin(yaw);
    final cp = math.cos(pitch), sp = math.sin(pitch);
    final path = Path();
    for (var s = 0; s <= _ringSegments; s++) {
      final t = s / _ringSegments * 2 * math.pi;
      final x = fx(t), y = fy(t), z = fz(t);
      final x1 = x * cy + z * sy;
      final z1 = -x * sy + z * cy;
      final y1 = y * cp - z1 * sp;
      final z2 = y * sp + z1 * cp;
      final p = _screen(c, x1, y1, z2);
      s == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      c,
      radius * 1.32,
      stroke
        ..color = line
        ..strokeWidth = 1,
    );
    for (var k = 0; k < 60; k++) {
      final a = k / 60 * 2 * math.pi + yaw * 0.3;
      final major = k % 5 == 0;
      final r0 = radius * (major ? 1.25 : 1.28);
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(
        c + dir * r0,
        c + dir * radius * 1.32,
        stroke
          ..color = accent.withValues(alpha: major ? 0.45 : 0.18)
          ..strokeWidth = major ? 1.5 : 1,
      );
    }

    stroke
      ..color = accent.withValues(alpha: 0.14)
      ..strokeWidth = 1;
    canvas.drawPath(_ring(c, math.cos, (_) => 0, math.sin), stroke);
    canvas.drawPath(_ring(c, math.cos, math.sin, (_) => 0), stroke);
    canvas.drawPath(_ring(c, (_) => 0, math.sin, math.cos), stroke..color = accent.withValues(alpha: 0.08));

    final fill = Paint()..style = PaintingStyle.fill;
    canvas.drawCircle(c, radius * 0.34, fill..color = accent.withValues(alpha: 0.05));
    canvas.drawCircle(c, radius * 0.22, fill..color = accent.withValues(alpha: 0.09));
    final d = radius * 0.12;
    final diamond = Path()
      ..moveTo(c.dx, c.dy - d)
      ..lineTo(c.dx + d, c.dy)
      ..lineTo(c.dx, c.dy + d)
      ..lineTo(c.dx - d, c.dy)
      ..close();
    canvas.drawPath(diamond, fill..color = accent.withValues(alpha: 0.85));
    canvas.drawCircle(
      c,
      radius * 0.2,
      stroke
        ..color = accent.withValues(alpha: 0.5)
        ..strokeWidth = 1.5,
    );

    final g = group;
    if (g != null) {
      Offset? prev;
      for (var i = 0; i < px.length; i++) {
        if (groupOfSkill[i] != g) continue;
        final p = _screen(c, px[i], py[i], pz[i]);
        canvas.drawLine(
          c,
          p,
          stroke
            ..color = accent.withValues(alpha: 0.12)
            ..strokeWidth = 1,
        );
        if (prev != null) {
          canvas.drawLine(
            prev,
            p,
            stroke
              ..color = accent.withValues(alpha: 0.55)
              ..strokeWidth = 1.4,
          );
        }
        prev = p;
      }
    }

    final s = _screen(c, px[selected], py[selected], pz[selected]);
    final front = ((pz[selected] + 1) / 2).clamp(0.2, 1.0);
    canvas.drawLine(
      c,
      s,
      stroke
        ..color = accent.withValues(alpha: 0.18 * front)
        ..strokeWidth = 7,
    );
    canvas.drawLine(
      c,
      s,
      stroke
        ..color = accent.withValues(alpha: 0.9 * front)
        ..strokeWidth = 1.6,
    );
    canvas.drawCircle(
      s,
      30,
      stroke
        ..color = accent.withValues(alpha: 0.35 * front)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _GalaxyPainter old) => true;
}
