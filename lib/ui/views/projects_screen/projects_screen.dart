import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/constants/data/projects.data.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../app/tokens/tokens.dart';
import '../../../core/models/project.model.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../widgets/components/gradient_title_placeholder.dart';
import '../../../widgets/components/page_shell.dart';
import '../../../widgets/components/section_header.dart';

part 'projects_screen.viewmodel.dart';

class ProjectsScreen extends StackedView<ProjectsScreenViewModel> {
  const ProjectsScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    ProjectsScreenViewModel viewModel,
    Widget? child,
  ) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width >= 900
        ? 2
        : width >= 600
            ? 2
            : 1;
    return SingleChildScrollView(
      child: PageShell(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpacingTokens.xl),
            const SectionHeader(
              title: 'Projects',
              subtitle: 'A curated collection of work and side projects.',
            ),
            const SizedBox(height: SpacingTokens.xxl),
            LayoutBuilder(
              builder: (context, constraints) {
                if (crossAxisCount == 1) {
                  return Column(
                    children: [
                      for (int i = 0; i < projectsList.length; i++) ...[
                        _ProjectCard(
                          project: projectsList[i],
                          index: i,
                        ),
                        if (i < projectsList.length - 1) const SizedBox(height: SpacingTokens.lg),
                      ],
                    ],
                  );
                }
                return Wrap(
                  spacing: SpacingTokens.lg,
                  runSpacing: SpacingTokens.lg,
                  children: [
                    for (int i = 0; i < projectsList.length; i++)
                      SizedBox(
                        width: (constraints.maxWidth - SpacingTokens.lg) / 2,
                        child: _ProjectCard(
                          project: projectsList[i],
                          index: i,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: SpacingTokens.xxl + SpacingTokens.lg),
          ],
        ),
      ),
    );
  }

  @override
  ProjectsScreenViewModel viewModelBuilder(BuildContext context) => ProjectsScreenViewModel();
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project, required this.index});
  final Project project;
  final int index;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final project = widget.project;
    final hasLink = project.demoUrl != null || project.githubUrl != null;
    final urlLauncher = locator.get<UrlLauncherService>();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: hasLink ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: hasLink ? () => urlLauncher.open(project.demoUrl ?? project.githubUrl!) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: c.bg1,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? c.accent.withAlpha(80) : c.line,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered ? c.accent.withAlpha(18) : Colors.black.withAlpha(8),
                blurRadius: _hovered ? 24 : 10,
                offset: Offset(0, _hovered ? 8 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (project.image != null && project.image!.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          project.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    GradientTitlePlaceholder(
                      title: project.name,
                      aspectRatio: 16 / 9,
                    ),
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(25),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c.bg1,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${widget.index + 1}'.padLeft(2, '0'),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: c.accent,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                  ),
                  if (hasLink)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: c.bg1,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.open_in_new_rounded,
                          size: 15,
                          color: c.textTertiary,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: c.textPrimary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: c.textSecondary,
                            height: 1.55,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (project.technologies.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: project.technologies.map((t) => _TechTag(label: t)).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TechTag extends StatelessWidget {
  const _TechTag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.accent.withAlpha(12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.accent.withAlpha(40)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: c.accent,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
      ),
    );
  }
}
