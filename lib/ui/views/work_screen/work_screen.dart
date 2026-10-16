import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/constants/data/blogs.data.dart';
import '../../../app/constants/data/projects.data.dart';
import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../core/models/project.model.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/fx/fx.dart';

part 'work_screen.viewmodel.dart';

class WorkScreen extends StackedView<WorkScreenViewModel> {
  const WorkScreen({super.key});

  @override
  Widget builder(BuildContext context, WorkScreenViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final pad = wide ? 64.0 : 24.0;
    final projects = viewModel.projects;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrambleText('Work', style: theme.textTheme.displaySmall?.copyWith(color: colors.textPrimary)),
                const SizedBox(height: 8),
                Text('Projects and writing', style: theme.textTheme.bodyLarge?.copyWith(color: colors.textSecondary)),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const gap = 20.0;
                    final cols = wide ? 2 : 1;
                    final itemWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (var i = 0; i < projects.length; i++)
                          SizedBox(
                            width: itemWidth,
                            child: Reveal(
                              delay: Duration(milliseconds: 60 * math.min(i, 6)),
                              child: _ProjectCard(project: projects[i], onOpen: viewModel.open),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 72),
                ScrambleText('Writing', style: theme.textTheme.headlineMedium?.copyWith(color: colors.textPrimary)),
                const SizedBox(height: 24),
                for (final blog in blogList) ...[
                  _BlogRow(blog: blog, onOpen: viewModel.open),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }

  @override
  WorkScreenViewModel viewModelBuilder(BuildContext context) => WorkScreenViewModel();
}

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
    return TiltCard(
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
                  if (github != null && github.isNotEmpty) _LinkButton(label: 'GITHUB', onTap: () => onOpen(github)),
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

class _BlogRow extends StatefulWidget {
  const _BlogRow({required this.blog, required this.onOpen});

  final BlogItem blog;
  final ValueChanged<String> onOpen;

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

    if (tappable) {
      row = Semantics(
        button: true,
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => widget.onOpen(url), child: row),
      );
    }
    return MouseRegion(
      cursor: tappable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: row,
    );
  }
}
