part of 'skill_galaxy.dart';

class _GalaxyNode extends StatefulWidget {
  const _GalaxyNode({
    required this.icon,
    required this.label,
    required this.selected,
    required this.highlighted,
    required this.showLabel,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final bool selected;
  final bool highlighted;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  State<_GalaxyNode> createState() => _GalaxyNodeState();
}

class _GalaxyNodeState extends State<_GalaxyNode> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final lit = widget.selected || widget.highlighted || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppMotion.short,
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.selected ? Color.lerp(c.bg1, c.accent, 0.18) : c.bg1,
                border: Border.all(
                  color: lit ? c.accent : c.accent.withValues(alpha: 0.25),
                  width: widget.selected ? 2 : 1,
                ),
              ),
              child: widget.icon,
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 16,
              child: OverflowBox(
                maxWidth: 160,
                child: AnimatedOpacity(
                  duration: AppMotion.short,
                  opacity: widget.showLabel || _hover ? 1 : 0,
                  child: Text(
                    widget.label,
                    softWrap: false,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: lit ? c.accent : c.textSecondary, fontSize: 11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanPanel extends StatelessWidget {
  const _ScanPanel({required this.skill, required this.group, required this.index, required this.total});

  final Skill skill;
  final String group;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final text = Theme.of(context).textTheme;
    final counter = '${(index + 1).toString().padLeft(2, '0')} / ${total.toString().padLeft(2, '0')}';
    return HudFrame(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: AppMotion.short,
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: Tween<double>(begin: 0.6, end: 1).animate(CurvedAnimation(parent: anim, curve: AppMotion.spring)),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: Container(
              key: ValueKey(index),
              width: 68,
              height: 68,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.bg2,
                border: Border.all(color: c.accent, width: 1.5),
              ),
              child: _SkillIcon(image: skill.image, size: 36),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Scanning  $counter', style: text.labelSmall?.copyWith(color: c.accent, letterSpacing: 1.5)),
                const SizedBox(height: 6),
                ScrambleText(
                  skill.title,
                  key: ValueKey(index),
                  reshuffleOnHover: false,
                  style: text.headlineSmall?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(group, style: text.bodyMedium?.copyWith(color: c.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupChip extends StatelessWidget {
  const _GroupChip({
    required this.label,
    required this.count,
    required this.active,
    required this.onHover,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final ValueChanged<bool> onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.short,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: active ? c.accent.withValues(alpha: 0.12) : Colors.transparent,
            border: Border.all(color: active ? c.accent : c.line),
          ),
          child: Text(
            '$label  $count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: active ? c.accent : c.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _SkillIcon extends StatelessWidget {
  const _SkillIcon({required this.image, required this.size});

  final String image;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(Icons.code_rounded, size: size, color: context.appColors.textTertiary);
    if (image.startsWith('http')) {
      return SvgPicture.network(
        image,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => fallback,
      );
    }
    return Image.asset(image, width: size, height: size, fit: BoxFit.contain, errorBuilder: (_, _, _) => fallback);
  }
}
