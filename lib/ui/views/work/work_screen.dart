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
import '../../../widgets/chrome/footer.dart';
import '../../../widgets/fx/fx.dart';

part 'work_screen.viewmodel.dart';
part 'sections/projects.dart';
part 'sections/blogs.dart';

class WorkScreen extends StackedView<WorkScreenViewModel> {
  const WorkScreen({super.key});

  @override
  Widget builder(BuildContext context, WorkScreenViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final pad = wide ? 64.0 : 24.0;
    final projects = viewModel.projects;

    return _WorkScroll(
      pad: pad,
      wide: wide,
      theme: theme,
      colors: colors,
      projects: projects,
      blogs: viewModel.blogs,
      onOpen: viewModel.open,
    );
  }

  @override
  WorkScreenViewModel viewModelBuilder(BuildContext context) => WorkScreenViewModel();
}

class _WorkScroll extends StatefulWidget {
  const _WorkScroll({
    required this.pad,
    required this.wide,
    required this.theme,
    required this.colors,
    required this.projects,
    required this.blogs,
    required this.onOpen,
  });

  final double pad;
  final bool wide;
  final ThemeData theme;
  final AppThemeColors colors;
  final List<Project> projects;
  final List<BlogItem> blogs;
  final ValueChanged<String> onOpen;

  @override
  State<_WorkScroll> createState() => _WorkScrollState();
}

class _WorkScrollState extends State<_WorkScroll> {
  final ScrollController _scroll = ScrollController();
  final ValueNotifier<double> _offset = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() => _offset.value = _scroll.offset);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = widget.pad;
    final wide = widget.wide;
    final theme = widget.theme;
    final colors = widget.colors;
    final projects = widget.projects;
    return SingleChildScrollView(
      controller: _scroll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListenableBuilder(
                  listenable: _offset,
                  builder: (context, child) {
                    final dy = AppMotion.reduceMotion(context) || !wide
                        ? 0.0
                        : (_offset.value * 0.08).clamp(-20.0, 36.0);
                    return Transform.translate(offset: Offset(0, dy), child: child);
                  },
                  child: ScrambleText('Work', style: theme.textTheme.displaySmall?.copyWith(color: colors.textPrimary)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 14,
                  child: Row(
                    children: [
                      CountUp(
                        value: projects.length,
                        style: theme.textTheme.titleMedium?.copyWith(color: colors.accent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: LineDraw(
                          strokeWidth: 1,
                          duration: AppMotion.long,
                          pathBuilder: (size) => Path()
                            ..moveTo(0, size.height / 2)
                            ..lineTo(size.width, size.height / 2),
                        ),
                      ),
                    ],
                  ),
                ),
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
                              kind: RevealKind.scaleIn,
                              delay: Duration(milliseconds: 60 * math.min(i, 6)),
                              child: _ProjectCard(project: projects[i], onOpen: widget.onOpen),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 72),
                ScrambleText('Writing', style: theme.textTheme.headlineMedium?.copyWith(color: colors.textPrimary)),
                const SizedBox(height: 24),
                RevealGroup(
                  kind: RevealKind.wipeLeft,
                  children: [
                    for (final blog in widget.blogs) ...[_BlogRow(blog: blog), const SizedBox(height: 12)],
                  ],
                ),
              ],
            ),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }
}
