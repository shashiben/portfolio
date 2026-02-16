import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/constants/data/awards.data.dart';
import '../../../app/constants/data/blogs.data.dart';
import '../../../app/constants/data/certificates.data.dart';
import '../../../app/constants/data/education.data.dart';
import '../../../app/constants/data/my_info.data.dart';
import '../../../app/constants/route_constants.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../app/theme/app_motion.dart';
import '../../../app/tokens/tokens.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../gen/assets.gen.dart';
import '../../../widgets/components/hover_fx.dart';
import '../../../widgets/components/page_shell.dart';
import '../../../widgets/components/section_header.dart';

part 'about_us_screen.viewmodel.dart';

class AboutUsScreen extends StackedView<AboutUsScreenViewModel> {
  const AboutUsScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    AboutUsScreenViewModel viewModel,
    Widget? child,
  ) {
    final isWide = MediaQuery.sizeOf(context).width >= 700;
    return SingleChildScrollView(
      child: PageShell(
        maxWidth: 720,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpacingTokens.lg),
            const SectionHeader(
              title: 'About',
              subtitle: 'Profile and background.',
            ),
            const SizedBox(height: SpacingTokens.xxl),
            _AboutProfileSection(isWide: isWide),
            const SizedBox(height: SpacingTokens.xxl),
            _AboutParagraph(),
            const SizedBox(height: SpacingTokens.xxl),
            _AboutDetailsSection(isWide: isWide),
            const SizedBox(height: SpacingTokens.xl),
            const SectionHeader(
              title: 'Education',
              subtitle: 'Academic background and qualifications.',
            ),
            const SizedBox(height: SpacingTokens.lg),
            ...educationList.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key < educationList.length - 1 ? SpacingTokens.md : 0,
                    ),
                    child: _EducationCard(entry: entry.value),
                  ),
                ),
            const SizedBox(height: SpacingTokens.xxl),
            SectionHeader(
              title: 'Certifications',
              subtitle: '${certificateList.length} credentials.',
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => router.go(RouteConstants.certificates),
              child: const Text('View all certificates'),
            ),
            const SizedBox(height: SpacingTokens.xxl),
            SectionHeader(
              title: 'Awards',
              subtitle: '${awardList.length} recognition${awardList.length == 1 ? '' : 's'}.',
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => router.go(RouteConstants.awards),
              child: const Text('View all awards'),
            ),
            const SizedBox(height: SpacingTokens.xxl),
            SectionHeader(
              title: 'Blogs',
              subtitle: '${blogList.length} articles.',
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => router.go(RouteConstants.blogs),
              child: const Text('View all blogs'),
            ),
            const SizedBox(height: SpacingTokens.xxl),
          ],
        ),
      ),
    );
  }

  @override
  AboutUsScreenViewModel viewModelBuilder(BuildContext context) => AboutUsScreenViewModel();
}

class _AboutProfileSection extends StatefulWidget {
  const _AboutProfileSection({required this.isWide});
  final bool isWide;

  @override
  State<_AboutProfileSection> createState() => _AboutProfileSectionState();
}

class _AboutProfileSectionState extends State<_AboutProfileSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.medium,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return FadeTransition(
      opacity: _opacity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HoverFx(
            hoverOnly: true,
            hoverScale: 1.04,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                Assets.images.avatar.path,
                width: 88,
                height: 88,
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: widget.isWide ? 24 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MYInfo.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: c.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  MYInfo.designation,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: c.accent,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Flutter', 'UI', 'Motion', 'Web + Mobile'].map((t) => _Chip(label: t)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutParagraph extends StatefulWidget {
  @override
  State<_AboutParagraph> createState() => _AboutParagraphState();
}

class _AboutParagraphState extends State<_AboutParagraph> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.medium,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final baseStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: c.textSecondary,
          height: 1.6,
        );
    final highlightStyle = baseStyle?.copyWith(
      color: c.accent,
      fontWeight: FontWeight.w600,
    );
    return FadeTransition(
      opacity: _opacity,
      child: RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(
              text:
                  "I'm Shashi Kumar, a full stack developer specializing in efficient Flutter applications that work across all platforms and browsers. I care deeply about building interfaces that are usable and pleasant for as many people as possible. My motto: always build ",
            ),
            TextSpan(text: 'pixel-perfect ', style: highlightStyle),
            TextSpan(text: 'high-performant ', style: highlightStyle),
            const TextSpan(
              text: 'applications that give users a rich experience.',
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutDetailsSection extends StatefulWidget {
  const _AboutDetailsSection({required this.isWide});
  final bool isWide;

  @override
  State<_AboutDetailsSection> createState() => _AboutDetailsSectionState();
}

class _AboutDetailsSectionState extends State<_AboutDetailsSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.medium,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 160), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: SpacingTokens.md),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: c.line),
            bottom: BorderSide(color: c.line),
          ),
        ),
        child: widget.isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DetailItem(label: 'Based in', value: 'India'),
                  _DetailItem(
                    label: 'Status',
                    value: 'Available',
                    onTap: () => router.go(RouteConstants.contact),
                  ),
                  _DetailItem(label: 'Focus', value: 'Clean · Minimal'),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailItem(label: 'Based in', value: 'India'),
                  const SizedBox(height: 12),
                  _DetailItem(
                    label: 'Status',
                    value: 'Available',
                    onTap: () => router.go(RouteConstants.contact),
                  ),
                  const SizedBox(height: 12),
                  _DetailItem(label: 'Focus', value: 'Clean · Minimal'),
                ],
              ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return HoverFx(
      hoverOnly: true,
      hoverScale: 1.05,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: c.bg2,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.transparent),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: c.textSecondary,
              ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.label,
    required this.value,
    this.onTap,
  });
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: c.textTertiary,
                fontSize: 12,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: c.textPrimary,
                fontWeight: onTap != null ? FontWeight.w600 : null,
              ),
        ),
      ],
    );
    if (onTap != null) {
      return HoverFx(
        hoverScale: 1.02,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: content,
          ),
        ),
      );
    }
    return content;
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.entry});
  final EducationEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return MouseRegion(
      cursor: entry.url != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: entry.url != null ? () => locator.get<UrlLauncherService>().open(entry.url!) : null,
        child: Container(
          padding: const EdgeInsets.all(SpacingTokens.lg),
          decoration: BoxDecoration(
            color: c.bg2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.institution,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: c.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.degree,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: c.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              entry.period,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: c.textTertiary,
                                    letterSpacing: 0.2,
                                  ),
                            ),
                            if (entry.score != null) ...[
                              Text(
                                ' · ',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c.textTertiary),
                              ),
                              Text(
                                entry.score!,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: c.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (entry.url != null)
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 16,
                      color: c.textTertiary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
