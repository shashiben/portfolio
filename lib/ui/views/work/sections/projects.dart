part of '../work_screen.dart';

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onOpen});

  final Project project;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final github = project.githubUrl;
    final demo = project.demoUrl;
    return DetailTrigger(
      kicker: 'Project',
      title: project.name,
      description: project.description,
      tags: project.technologies,
      links: [
        if (github != null && github.isNotEmpty) DetailLink('GitHub', github),
        if (demo != null && demo.isNotEmpty) DetailLink('Demo', demo),
      ],
      child: TiltCard(
        child: ScanSweep(
          child: HudFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ScrambleText(project.name, style: theme.textTheme.titleLarge?.copyWith(color: colors.textPrimary)),
                const SizedBox(height: 10),
                Text(
                  project.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tech in project.technologies)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.accent.withValues(alpha: 0.08),
                          border: Border.all(color: colors.accent.withValues(alpha: 0.25)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(tech, style: theme.textTheme.labelSmall?.copyWith(color: colors.accent)),
                      ),
                  ],
                ),
                if ((github?.isNotEmpty ?? false) || (demo?.isNotEmpty ?? false)) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (github != null && github.isNotEmpty)
                        _LinkButton(label: 'GITHUB', onTap: () => onOpen(github)),
                      if (demo != null && demo.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        _LinkButton(label: 'DEMO', onTap: () => onOpen(demo)),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MagneticButton(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text('$label ↗', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.accent)),
      ),
    );
  }
}
