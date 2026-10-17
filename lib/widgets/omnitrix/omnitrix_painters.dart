part of 'omnitrix.dart';

class _OuterRingPainter extends CustomPainter {
  _OuterRingPainter({required this.innerRadius, required this.glow, required this.glowSpread}) : super(repaint: glow);

  final double innerRadius;

  /// Shutter progress; the halo only exists while the shutter is moving.
  final Animation<double> glow;
  final double glowSpread;

  final Paint _fill = Paint()..color = const Color(0xFF363636);
  final Paint _stroke = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint _halo = Paint();
  Path? _ring;
  Size? _ringSize;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outerRadius = size.width / 2;

    final g = glow.value;
    if (g > 0) {
      _halo.color = Colors.greenAccent.withValues(alpha: 0.1 * g);
      canvas.drawCircle(center, outerRadius + glowSpread, _halo);
      _halo.color = Colors.greenAccent.withValues(alpha: 0.16 * g);
      canvas.drawCircle(center, outerRadius + glowSpread / 2, _halo);
    }

    if (_ringSize != size) {
      _ringSize = size;
      _ring = Path.combine(
        PathOperation.difference,
        Path()..addOval(Rect.fromCircle(center: center, radius: outerRadius)),
        Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius)),
      );
    }
    canvas
      ..drawPath(_ring!, _fill)
      ..drawPath(_ring!, _stroke);
  }

  @override
  bool shouldRepaint(covariant _OuterRingPainter old) =>
      old.innerRadius != innerRadius || old.glow != glow || old.glowSpread != glowSpread;
}

class _ShockwavePainter extends CustomPainter {
  _ShockwavePainter(this.t, this.scale) : super(repaint: t);

  final Animation<double> t;
  final double scale;
  final Paint _paint = Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final v = t.value;
    if (v <= 0 || v >= 1) return;
    final e = AppMotion.easeOut.transform(v);
    _paint
      ..strokeWidth = 1 + 6 * scale * (1 - e)
      ..color = ColorTokens.omniGreen.withValues(alpha: 1 - v);
    canvas.drawCircle(size.center(Offset.zero), e * size.width, _paint);
  }

  @override
  bool shouldRepaint(covariant _ShockwavePainter old) => old.t != t || old.scale != scale;
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width * 0.5, 0)
    ..lineTo(0, size.height * 0.5)
    ..lineTo(size.width * 0.5, size.height)
    ..lineTo(size.width, size.height * 0.5)
    ..lineTo(size.width * 0.5, 0)
    ..close();

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
