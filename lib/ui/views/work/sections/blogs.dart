part of '../work_screen.dart';

class _BlogRow extends StatefulWidget {
  const _BlogRow({required this.blog});

  final BlogItem blog;

  @override
  State<_BlogRow> createState() => _BlogRowState();
}

class _BlogRowState extends State<_BlogRow> {
  bool _hover = false;

  static Path _wave(Size size) {
    final path = Path();
    final mid = size.height / 2;
    const segments = 48;
    for (var i = 0; i <= segments; i++) {
      final x = size.width * i / segments;
      final t = i / segments * math.pi * 6;
      final y = mid + math.sin(t) * mid * 0.8 * (0.4 + 0.6 * math.sin(t / 6).abs());
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final blog = widget.blog;
    final url = blog.url;
    final tappable = url != null && url.isNotEmpty;

    Widget row = AnimatedContainer(
      duration: AppMotion.short,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _hover ? colors.bg2 : colors.bg1.withValues(alpha: 0.4),
        border: Border(left: BorderSide(color: _hover ? colors.accent : colors.line, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (blog.date != null)
            Text(blog.date!, style: theme.textTheme.labelSmall?.copyWith(color: colors.textTertiary)),
          const SizedBox(height: 6),
          ScrambleText(blog.title, style: theme.textTheme.titleMedium?.copyWith(color: colors.textPrimary)),
          const SizedBox(height: 6),
          Text(
            blog.excerpt,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 20,
            width: double.infinity,
            child: LineDraw(pathBuilder: _wave, strokeWidth: 1.2, autoPlay: true),
          ),
        ],
      ),
    );

    return DetailTrigger(
      kicker: 'Writing',
      title: blog.title,
      description: blog.excerpt,
      facts: [if (blog.date != null) DetailFact('Date', blog.date!)],
      links: [if (tappable) DetailLink('Read', url)],
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: row,
      ),
    );
  }
}
