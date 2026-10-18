part of '../home_screen.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {this.metric});

  final String text;
  final int? metric;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final style = Theme.of(context).textTheme.headlineSmall
        ?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.only(top: 96, bottom: 32),
      child: Row(
        children: [
          Container(width: 8, height: 8, color: c.accent),
          const SizedBox(width: 12),
          ScrambleText(text, style: style),
          if (metric != null) ...[
            const SizedBox(width: 14),
            CountUp(
              value: metric!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: c.accent),
            ),
          ],
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 12,
              child: LineDraw(
                strokeWidth: 1,
                duration: AppMotion.long,
                pathBuilder: (size) => Path()
                  ..moveTo(0, size.height / 2)
                  ..lineTo(size.width, size.height / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HexClipper extends CustomClipper<Path> {
  const _HexClipper();

  @override
  Path getClip(Size size) => _hexPath(size);

  @override
  bool shouldReclip(covariant _HexClipper oldClipper) => false;
}

Path _hexPath(Size s) {
  final cx = s.width / 2, cy = s.height / 2;
  final r = math.min(s.width, s.height) / 2;
  final path = Path();
  for (var i = 0; i < 6; i++) {
    final a = -math.pi / 2 + i * math.pi / 3;
    final p = Offset(cx + r * math.cos(a), cy + r * math.sin(a));
    i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
  }
  return path..close();
}

class _HexBorderPainter extends CustomPainter {
  _HexBorderPainter({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _hexPath(Size(size.width - width, size.height - width)).shift(Offset(width / 2, width / 2)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _HexBorderPainter old) => old.color != color || old.width != width;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onTap, this.filled = false});

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return MagneticButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: filled ? c.accent : Colors.transparent,
          border: Border.all(color: c.accent),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: filled ? c.bg0 : c.accent, letterSpacing: 1.8, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
