part of '../home_screen.dart';

class _Hero extends StatefulWidget {
  const _Hero({required this.onContact, required this.onWork, this.parallax});

  final VoidCallback onContact;
  final VoidCallback onWork;
  final ValueListenable<double>? parallax;

  @override
  State<_Hero> createState() => _HeroState();
}

class _HeroState extends State<_Hero> {
  final ValueNotifier<double> _spin = ValueNotifier<double>(0);

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final wide = _isWide(context);
    final text = Theme.of(context).textTheme;

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(MYInfo.designation, style: text.labelSmall?.copyWith(color: c.accent, letterSpacing: 2)),
        const SizedBox(height: 16),
        ScrambleText(
          'Building products that scale.',
          style: text.displayLarge?.copyWith(color: c.textPrimary, fontSize: wide ? 56 : 36, height: 1.08),
        ),
        const SizedBox(height: 20),
        EnergyStroke(
          child: Text(MYInfo.designation, style: text.titleLarge?.copyWith(color: c.textPrimary)),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Full-stack development. Mobile & web. Delivering impact through clean code and thoughtful design.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.bodyLarge?.copyWith(color: c.textSecondary, height: 1.5),
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _ActionButton(label: 'Get in touch', filled: true, onTap: widget.onContact),
            _ActionButton(label: 'View work', onTap: widget.onWork),
          ],
        ),
      ],
    );

    final width = MediaQuery.sizeOf(context).width;
    final coreSize = wide ? 340.0 : math.min(340.0, width - 48);
    final dialSize = coreSize * 0.86;
    final dial = SizedBox.square(
      dimension: coreSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          IgnorePointer(
            child: ClipOval(
              child: OmnitrixCore3D(size: dialSize, spin: _spin),
            ),
          ),
          OmnitrixWidget(size: dialSize, spin: _spin),
        ],
      ),
    );
    final parallax = widget.parallax;
    final device = parallax == null
        ? dial
        : ListenableBuilder(
            listenable: parallax,
            builder: (context, child) {
              final shift = _parallaxOf(context, parallax.value);
              return Transform.translate(offset: Offset(0, shift), child: child);
            },
            child: dial,
          );

    return Padding(
      padding: EdgeInsets.only(top: wide ? 96 : 48),
      child: wide
          ? Row(
              children: [
                Expanded(child: copy),
                const SizedBox(width: 48),
                device,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                copy,
                const SizedBox(height: 48),
                Center(child: device),
              ],
            ),
    );
  }
}
