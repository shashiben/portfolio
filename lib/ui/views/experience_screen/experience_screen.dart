import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.router.dart';
import '../../../app/constants/data/awards.data.dart';
import '../../../app/constants/data/experience.data.dart';
import '../../../app/constants/route_constants.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../app/tokens/tokens.dart';
import '../../../core/models/company.model.dart';
import '../../../widgets/components/gradient_title_placeholder.dart';
import '../../../widgets/components/page_shell.dart';
import '../../../widgets/components/section_header.dart';

part 'experience_screen.viewmodel.dart';

class ExperienceScreen extends StackedView<ExperienceScreenViewModel> {
  const ExperienceScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    ExperienceScreenViewModel viewModel,
    Widget? child,
  ) {
    return SingleChildScrollView(
      child: PageShell(
        maxWidth: 740,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpacingTokens.xl),
            const SectionHeader(
              title: 'Experience',
              subtitle: 'Career journey and key milestones.',
            ),
            const SizedBox(height: SpacingTokens.xxl),
            ...experienceList.asMap().entries.toList().reversed.map(
                  (entry) => _TimelineEntry(
                    company: entry.value,
                    isLast: entry.key == 0,
                    isFirst: entry.key == experienceList.length - 1,
                  ),
                ),
            const SizedBox(height: SpacingTokens.xxl),
          ],
        ),
      ),
    );
  }

  @override
  ExperienceScreenViewModel viewModelBuilder(BuildContext context) =>
      ExperienceScreenViewModel();
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.company,
    this.isFirst = false,
    this.isLast = false,
  });

  final Company company;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isMobile = MediaQuery.sizeOf(context).width < 500;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: isMobile ? 32 : 48,
            child: Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    width: 1.5,
                    height: isFirst ? 8 : 0,
                    color: isFirst ? Colors.transparent : c.line,
                  ),
                ),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFirst ? c.accent : c.bg1,
                    border: Border.all(
                      color: isFirst ? c.accent : c.line,
                      width: 2,
                    ),
                    boxShadow: isFirst
                        ? [
                            BoxShadow(
                              color: c.accent.withAlpha(50),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: isLast ? Colors.transparent : c.line,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : SpacingTokens.lg,
              ),
              child: _ExperienceCard(
                company: company,
                isCurrent: company.isCurrent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  const _ExperienceCard({
    required this.company,
    this.isCurrent = false,
  });

  final Company company;
  final bool isCurrent;

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovered = false;

  static String _cleanPoint(String raw) {
    return raw
        .replaceAll(RegExp(r"\[b'[^']*']"), '')
        .replaceAll('%20', ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final company = widget.company;
    final isMobile = MediaQuery.sizeOf(context).width < 500;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        decoration: BoxDecoration(
          color: c.bg1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered
                ? c.accent.withAlpha(60)
                : widget.isCurrent
                    ? c.accent.withAlpha(30)
                    : c.line,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  _hovered ? c.accent.withAlpha(12) : Colors.black.withAlpha(5),
              blurRadius: _hovered ? 20 : 8,
              offset: Offset(0, _hovered ? 4 : 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (company.image != null && company.image!.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: c.line),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.asset(
                        company.image!,
                        width: isMobile ? 42 : 52,
                        height: isMobile ? 42 : 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => SizedBox(
                          width: isMobile ? 42 : 52,
                          height: isMobile ? 42 : 52,
                          child: GradientTitlePlaceholder(
                            title: company.name.split(' ').take(2).join(' '),
                            aspectRatio: 1,
                            borderRadius: BorderRadius.circular(10),
                            compact: true,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: isMobile ? 42 : 52,
                    height: isMobile ? 42 : 52,
                    child: GradientTitlePlaceholder(
                      title: company.name.split(' ').take(2).join(' '),
                      aspectRatio: 1,
                      borderRadius: BorderRadius.circular(10),
                      compact: true,
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: c.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              widget.isCurrent ? c.accent.withAlpha(12) : c.bg2,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          company.period,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: widget.isCurrent
                                        ? c.accent
                                        : c.textTertiary,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: c.success.withAlpha(15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: c.success.withAlpha(40),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c.success,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Current',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: c.success,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                height: 1,
                color: c.line.withAlpha(160),
              ),
            ),
            ...company.points.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key < company.points.length - 1 ? 10 : 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  widget.isCurrent ? c.accent : c.textTertiary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _cleanPoint(entry.value),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: c.textSecondary,
                                  height: 1.55,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            if (company.subEntries.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SubTimeline(
                subEntries: company.subEntries,
                isCurrent: widget.isCurrent,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SubTimeline extends StatelessWidget {
  const _SubTimeline({
    required this.subEntries,
    this.isCurrent = false,
  });

  final List<ExperienceSubEntry> subEntries;
  final bool isCurrent;

  static String _cleanPoint(String raw) {
    return raw
        .replaceAll(RegExp(r"\[b'[^']*']"), '')
        .replaceAll('%20', ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < subEntries.length; i++) ...[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrent ? c.accent : c.textTertiary,
                          border: Border.all(
                            color: isCurrent ? c.accent : c.line,
                            width: 1.5,
                          ),
                        ),
                      ),
                      if (i < subEntries.length - 1)
                        Expanded(
                          child: Center(
                            child: Container(
                              width: 1.5,
                              color: c.line,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: i < subEntries.length - 1 ? 20 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (subEntries[i].title != null)
                              Text(
                                subEntries[i].title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: c.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            if (subEntries[i].title != null)
                              const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: c.bg2,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                subEntries[i].period,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: c.textTertiary,
                                      fontSize: 11,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...subEntries[i].points.map(
                              (p) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Container(
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: c.textTertiary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _cleanPoint(p),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: c.textSecondary,
                                              height: 1.5,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        if (subEntries[i].awardIds.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: subEntries[i]
                                .awardIds
                                .map((id) => getAwardById(id))
                                .whereType<AwardItem>()
                                .map(
                                  (award) => MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => router.go(
                                        '${RouteConstants.awards}?id=${award.id}',
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: c.accent.withAlpha(25),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: c.accent.withAlpha(80),
                                          ),
                                        ),
                                        child: Text(
                                          award.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: c.accent,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
