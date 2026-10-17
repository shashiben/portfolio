part of '../home_screen.dart';

class _Origin extends StatelessWidget {
  const _Origin();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final wide = _isWide(context);

    final bio = Reveal(
      child: Text(
        MYInfo.aboutBodyText1,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: c.textSecondary, height: 1.7, fontSize: 18),
      ),
    );

    final stats = Wrap(
      spacing: 40,
      runSpacing: 24,
      children: [
        _Stat(value: DateTime.now().year - 2021, label: 'Years', suffix: '+'),
        const _Stat(value: 12, label: 'Apps shipped'),
        _Stat(value: awardList.length, label: 'Awards'),
      ],
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [bio, const SizedBox(height: 40), stats],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('About'),
        if (wide)
          Row(
            children: [
              const _HexAvatar(size: 220),
              const SizedBox(width: 56),
              Expanded(child: text),
              const SizedBox(width: 32),
              const IgnorePointer(child: DnaHelix(size: 140)),
            ],
          )
        else ...[
          const Center(child: _HexAvatar(size: 180)),
          const SizedBox(height: 32),
          text,
        ],
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.suffix = ''});

  final int value;
  final String label;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CountUp(
          value: value,
          suffix: suffix,
          style: text.displaySmall?.copyWith(color: c.accent),
        ),
        const SizedBox(height: 4),
        Text(label, style: text.labelSmall?.copyWith(color: c.textSecondary, letterSpacing: 2)),
      ],
    );
  }
}

class _HexAvatar extends StatefulWidget {
  const _HexAvatar({required this.size});

  final double size;

  @override
  State<_HexAvatar> createState() => _HexAvatarState();
}

class _HexAvatarState extends State<_HexAvatar> with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(vsync: this, duration: const Duration(seconds: 14));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduceMotion(context)) {
      _spin.stop();
    } else if (!_spin.isAnimating) {
      _spin.repeat();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final ring = widget.size + 36;
    return SizedBox.square(
      dimension: ring,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _spin,
            child: CustomPaint(size: Size.square(ring), painter: _ArcPainter(c.accent)),
          ),
          SizedBox.square(
            dimension: widget.size,
            child: CustomPaint(
              foregroundPainter: _HexBorderPainter(color: c.accent.withValues(alpha: 0.8), width: 2),
              child: ClipPath(
                clipper: const _HexClipper(),
                child: Image.asset(Assets.images.avatar.path, fit: BoxFit.cover, alignment: Alignment.topCenter),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..color = color;
    canvas
      ..drawArc(rect, 0, math.pi * 0.6, false, paint)
      ..drawArc(rect, math.pi, math.pi * 0.35, false, paint..color = color.withValues(alpha: 0.5));
    final inner = rect.deflate(8);
    canvas.drawArc(inner, math.pi * 0.4, math.pi * 0.25, false, paint..color = color.withValues(alpha: 0.3));
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) => old.color != color;
}
