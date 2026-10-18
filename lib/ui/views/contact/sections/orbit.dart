part of '../contact_us_screen.dart';

class _SocialOrbit extends StatefulWidget {
  const _SocialOrbit({required this.onOpen});

  final ValueChanged<String> onOpen;

  @override
  State<_SocialOrbit> createState() => _SocialOrbitState();
}

class _SocialOrbitState extends State<_SocialOrbit> with TickerProviderStateMixin {
  static const double _size = 280;
  static const double _radius = 112;
  static const double _node = 40;
  static const List<(FaIconData, String, String)> _nodes = [
    (FontAwesomeIcons.github, 'GitHub', MYInfo.github),
    (FontAwesomeIcons.linkedin, 'LinkedIn', MYInfo.linkedIn),
    (FontAwesomeIcons.medium, 'Medium', MYInfo.medium),
    (FontAwesomeIcons.stackOverflow, 'Stack Overflow', MYInfo.stackOverflow),
    (FontAwesomeIcons.instagram, 'Instagram', MYInfo.instagram),
    (FontAwesomeIcons.xTwitter, 'Twitter', MYInfo.twitter),
    (FontAwesomeIcons.telegram, 'Telegram', MYInfo.telegram),
    (FontAwesomeIcons.whatsapp, 'WhatsApp', MYInfo.whatsappLink),
  ];

  late final AnimationController _spin = AnimationController(vsync: this, duration: const Duration(seconds: 20));
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  int? _hovered;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (fxReduceMotion(context)) {
      _spin.stop();
      _pulse.value = 0.5;
      _pulse.stop();
    } else {
      if (!_spin.isAnimating) _spin.repeat();
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Offset _pos(int i) {
    final a = _spin.value * 2 * math.pi + i * 2 * math.pi / _nodes.length - math.pi / 2;
    return Offset(_size / 2 + _radius * math.cos(a), _size / 2 + _radius * math.sin(a));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return SizedBox.square(
      dimension: _size,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([_spin, _pulse]),
          builder: (context, _) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _OrbitPainter(
                      color: c.accent,
                      radius: _radius,
                      pulse: _pulse.value,
                      target: _hovered == null ? null : _pos(_hovered!),
                    ),
                  ),
                ),
                for (var i = 0; i < _nodes.length; i++)
                  Positioned(
                    left: _pos(i).dx - _node / 2,
                    top: _pos(i).dy - _node / 2,
                    child: Tooltip(
                      message: _nodes[i].$2,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => _hovered = i),
                        onExit: (_) => setState(() => _hovered = null),
                        child: GestureDetector(
                          onTap: () => widget.onOpen(_nodes[i].$3),
                          child: AnimatedScale(
                            scale: _hovered == i ? 1.2 : 1,
                            duration: const Duration(milliseconds: 160),
                            child: Container(
                              width: _node,
                              height: _node,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: c.bg1,
                                border: Border.all(
                                  color: c.accent.withValues(alpha: _hovered == i ? 1 : 0.45),
                                  width: _hovered == i ? 1.5 : 1,
                                ),
                              ),
                              child: FaIcon(_nodes[i].$1, size: 16, color: _hovered == i ? c.accent : c.textSecondary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({required this.color, required this.radius, required this.pulse, this.target});

  final Color color;
  final double radius;
  final double pulse;
  final Offset? target;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = color.withValues(alpha: 0.18),
    );
    if (target != null) {
      canvas.drawLine(
        center,
        target!,
        Paint()
          ..strokeWidth = 4
          ..color = color.withValues(alpha: 0.15),
      );
      canvas.drawLine(
        center,
        target!,
        Paint()
          ..strokeWidth = 1.5
          ..color = color,
      );
    }
    final core = 22 + 4 * pulse;
    canvas.drawCircle(center, core + 14, Paint()..color = color.withValues(alpha: 0.06 + 0.06 * pulse));
    canvas.drawCircle(center, core + 6, Paint()..color = color.withValues(alpha: 0.14 + 0.1 * pulse));
    canvas.drawCircle(center, core, Paint()..color = color.withValues(alpha: 0.85));
    canvas.drawCircle(center, core * 0.4, Paint()..color = Color.lerp(color, Colors.white, 0.6)!);
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter old) =>
      old.pulse != pulse || old.target != target || old.color != color || old.radius != radius;
}
