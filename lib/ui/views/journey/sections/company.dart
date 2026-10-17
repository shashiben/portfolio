part of '../journey_screen.dart';

class _CompanyCard extends StatelessWidget {
  const _CompanyCard({required this.company});

  final Company company;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final theme = Theme.of(context).textTheme;
    final image = company.image;

    return HudFrame(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    image,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox(width: 44, height: 44),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: theme.titleLarge?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      company.period.toUpperCase(),
                      style: theme.labelMedium?.copyWith(color: c.textTertiary, letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
              if (company.isCurrent) ...[const SizedBox(width: 12), const _ActiveBadge()],
            ],
          ),
          const SizedBox(height: 20),
          if (company.subEntries.isNotEmpty)
            for (var i = 0; i < company.subEntries.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: i == company.subEntries.length - 1 ? 0 : 24),
                child: _RoleBlock(entry: company.subEntries[i]),
              )
          else
            _Bullets(points: company.points),
        ],
      ),
    );
  }
}

class _RoleBlock extends StatelessWidget {
  const _RoleBlock({required this.entry});

  final ExperienceSubEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final theme = Theme.of(context).textTheme;
    final awards = entry.awardIds.isEmpty
        ? const <AwardItem>[]
        : awardList.where((a) => entry.awardIds.contains(a.id)).toList();

    return Container(
      padding: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: c.line, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (entry.title != null)
                Text(
                  entry.title!,
                  style: theme.titleMedium?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
                ),
              Text(entry.period, style: theme.labelMedium?.copyWith(color: c.textTertiary)),
            ],
          ),
          const SizedBox(height: 10),
          _Bullets(points: entry.points),
          if (awards.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < awards.length; i++)
                  Reveal(
                    delay: Duration(milliseconds: 80 * i),
                    child: _AwardChip(award: awards[i]),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.points});

  final List<String> points;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.textSecondary, height: 1.55);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final p in points)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(width: 5, height: 5, color: c.accent),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(p, style: style)),
              ],
            ),
          ),
      ],
    );
  }
}
