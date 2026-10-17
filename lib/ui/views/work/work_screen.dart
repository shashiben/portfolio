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
