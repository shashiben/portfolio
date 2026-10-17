part of '../journey_screen.dart';

class _AwardChip extends StatelessWidget {
  const _AwardChip({required this.award});

  final AwardItem award;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.accent.withValues(alpha: 0.08),
        border: Border.all(color: c.accent.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACHIEVEMENT UNLOCKED',
            style: theme.labelSmall?.copyWith(
              color: c.accent,
              fontSize: 9,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            award.name,
            style: theme.labelMedium?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ActiveBadge extends StatefulWidget {
  const _ActiveBadge();

  @override
  State<_ActiveBadge> createState() => _ActiveBadgeState();
}

class _ActiveBadgeState extends State<_ActiveBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
    lowerBound: 0.25,
    value: 1,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduceMotion(context)) {
      _blink
        ..stop()
        ..value = 1;
    } else if (!_blink.isAnimating) {
      _blink.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _blink.stop();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return FadeTransition(
      opacity: _blink,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: c.success),
          ),
          const SizedBox(width: 6),
          Text(
            'ACTIVE',
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: c.success, letterSpacing: 2, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
