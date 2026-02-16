import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.router.dart';
import '../../../app/constants/data/my_info.data.dart';
import '../../../app/constants/route_constants.dart';
import '../../../gen/assets.gen.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../app/tokens/tokens.dart';
import '../../../widgets/omnitrix.dart';

part 'home_screen.viewmodel.dart';

class HomeScreen extends StackedView<HomeScreenViewModel> {
  const HomeScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeScreenViewModel viewModel,
    Widget? child,
  ) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroSection(),
          _TechStackSection(),
          _PillarSection(),
          _PlatformSection(),
          _FooterCta(),
        ],
      ),
    );
  }

  @override
  HomeScreenViewModel viewModelBuilder(BuildContext context) =>
      HomeScreenViewModel();
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isWide = MediaQuery.sizeOf(context).width >= 800;
    return Container(
      width: double.infinity,
      color: c.bg0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? SpacingTokens.xxl * 2 : SpacingTokens.lg,
            vertical: isWide ? SpacingTokens.xxl * 2.5 : SpacingTokens.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MYInfo.designation,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: c.accent,
                      letterSpacing: 0.5,
                    ),
              ),
              SizedBox(height: isWide ? SpacingTokens.md : SpacingTokens.smd),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Building products\nthat scale.',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: c.textPrimary,
                                fontSize: isWide ? 52 : 36,
                                height: 1.08,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.02,
                              ),
                        ),
                        const SizedBox(height: SpacingTokens.md),
                        Text(
                          'Full-stack development. Mobile & web. Delivering impact through clean code and thoughtful design.',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: c.textSecondary,
                                    height: 1.5,
                                    fontSize: isWide ? 18 : 16,
                                  ),
                        ),
                        const SizedBox(height: SpacingTokens.xxxl),
                        Row(
                          children: [
                            FilledButton(
                              onPressed: () =>
                                  router.go(RouteConstants.contact),
                              child: const Text('Get in touch'),
                            ),
                            const SizedBox(width: SpacingTokens.md),
                            OutlinedButton(
                              onPressed: () =>
                                  router.go(RouteConstants.projects),
                              child: const Text('View projects'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isWide) ...[
                    const SizedBox(width: 48),
                    SizedBox(width: 300, child: const OmnitrixWidget()),
                  ],
                ],
              ),
              if (!isWide) ...[
                const SizedBox(height: SpacingTokens.section),
                Center(
                  child: const OmnitrixWidget(),
                ),
                const SizedBox(height: SpacingTokens.xxl),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TechStackSection extends StatefulWidget {
  const _TechStackSection();

  @override
  State<_TechStackSection> createState() => _TechStackSectionState();
}

class _TechStackSectionState extends State<_TechStackSection>
    with SingleTickerProviderStateMixin {
  static final _techItems = [
    (icon: Assets.icons.flutter, label: 'Flutter'),
    (icon: Assets.icons.python, label: 'Python'),
    (icon: Assets.icons.react, label: 'React'),
    (icon: Assets.icons.kotlin, label: 'Kotlin'),
    (icon: Assets.icons.mongo, label: 'MongoDB'),
    (icon: Assets.icons.firebase, label: 'Firebase'),
    (icon: Assets.icons.git, label: 'Git'),
    (icon: Assets.icons.django, label: 'Django'),
  ];

  late AnimationController _marqueeController;

  @override
  void initState() {
    super.initState();
    _marqueeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _marqueeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isWide = MediaQuery.sizeOf(context).width >= 800;
    final spacing = isWide
        ? SpacingTokens.marqueeSpacingWide
        : SpacingTokens.marqueeSpacing;
    final chipWidth = SpacingTokens.marqueeChipWidth;
    final contentWidth =
        _techItems.length * chipWidth + (_techItems.length - 1) * spacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? SpacingTokens.xxl * 2 : SpacingTokens.lg,
        vertical: SpacingTokens.xxl,
      ),
      decoration: BoxDecoration(
        color: c.bg2,
        border: Border(
          top: BorderSide(color: c.line),
          bottom: BorderSide(color: c.line),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tech stack',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            'Tools and technologies I work with',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: c.textTertiary,
                ),
          ),
          SizedBox(height: isWide ? SpacingTokens.xxxl : SpacingTokens.xl),
          ClipRect(
            child: SizedBox(
              height: SpacingTokens.marqueeHeight,
              width: double.infinity,
              child: OverflowBox(
                alignment: Alignment.centerLeft,
                minWidth: 0,
                maxWidth: double.infinity,
                child: AnimatedBuilder(
                  animation: _marqueeController,
                  builder: (context, child) {
                    final offset =
                        _marqueeController.value * (contentWidth + spacing);
                    return Transform.translate(
                      offset: Offset(-offset, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < 4; i++)
                            ..._techItems.map(
                              (item) => Padding(
                                padding: EdgeInsets.only(right: spacing),
                                child: _TechChip(
                                  icon: item.icon,
                                  label: item.label,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatefulWidget {
  const _TechChip({
    required this.icon,
    required this.label,
  });

  final AssetGenImage icon;
  final String label;

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _isHovered = false;

  static const _grayscaleMatrix = <double>[
    0.2126,
    0.7152,
    0.0722,
    0.0,
    0.0,
    0.2126,
    0.7152,
    0.0722,
    0.0,
    0.0,
    0.2126,
    0.7152,
    0.0722,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final image = Image.asset(
      widget.icon.path,
      width: 22,
      height: 22,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.code_rounded,
        size: 22,
        color: c.textTertiary,
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: _isHovered ? 1 : 0.85,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.chipPaddingH,
            vertical: SpacingTokens.chipPaddingV,
          ),
          decoration: BoxDecoration(
            color: c.bg1,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.line),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isHovered
                  ? image
                  : ColorFiltered(
                      colorFilter: const ColorFilter.matrix(_grayscaleMatrix),
                      child: image,
                    ),
              const SizedBox(width: SpacingTokens.sm),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: c.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillarSection extends StatelessWidget {
  const _PillarSection();

  static const List<_PillarData> _pillars = [
    _PillarData(
      title: 'Full-stack by design',
      body:
          'Build, ship, and iterate with full control—from backend APIs to polished UIs.',
    ),
    _PillarData(
      title: 'Mobile & Web',
      body:
          'Flutter and modern web tech across platforms. One codebase, consistent quality.',
    ),
    _PillarData(
      title: 'Human at the core',
      body:
          'Collaborative development with clear communication and production-ready delivery.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isWide = MediaQuery.sizeOf(context).width >= 800;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? SpacingTokens.xxl * 2 : SpacingTokens.lg,
        vertical: SpacingTokens.xxl * 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What I bring to the table',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: SpacingTokens.gap),
          Text(
            'For startups · teams · products',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: c.textTertiary,
                ),
          ),
          SizedBox(height: isWide ? SpacingTokens.gapXl : SpacingTokens.xxxl),
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _pillars
                      .map(
                        (p) => Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: SpacingTokens.xxl),
                            child: _PillarCard(title: p.title, body: p.body),
                          ),
                        ),
                      )
                      .toList(),
                )
              : Column(
                  children: _pillars
                      .map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: SpacingTokens.gapLg),
                          child: _PillarCard(title: p.title, body: p.body),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _PillarData {
  const _PillarData({required this.title, required this.body});
  final String title;
  final String body;
}

class _PillarCard extends StatelessWidget {
  const _PillarCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: c.bg1,
        borderRadius: BorderRadius.circular(SpacingTokens.cardRadius),
        border: Border.all(color: c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: SpacingTokens.gap),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: c.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _PlatformSection extends StatelessWidget {
  const _PlatformSection();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isWide = MediaQuery.sizeOf(context).width >= 800;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? SpacingTokens.xxl * 2 : SpacingTokens.lg,
        vertical: SpacingTokens.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experience & projects',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: SpacingTokens.gap),
          Text(
            'Years of hands-on work across the stack.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: c.textTertiary,
                ),
          ),
          const SizedBox(height: SpacingTokens.xxl),
          Row(
            children: [
              Expanded(
                child: _PlatformCard(
                  title: 'Experience',
                  subtitle: 'Roles and impact',
                  onTap: () => router.go(RouteConstants.experience),
                ),
              ),
              if (isWide) const SizedBox(width: 20),
              if (isWide)
                Expanded(
                  child: _PlatformCard(
                    title: 'Projects',
                    subtitle: "What I've built",
                    onTap: () => router.go(RouteConstants.projects),
                  ),
                ),
            ],
          ),
          if (!isWide) ...[
            const SizedBox(height: 16),
            _PlatformCard(
              title: 'Projects',
              subtitle: "What I've built",
              onTap: () => router.go(RouteConstants.projects),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlatformCard extends StatelessWidget {
  const _PlatformCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SpacingTokens.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(SpacingTokens.lg),
          decoration: BoxDecoration(
            color: c.bg1,
            borderRadius: BorderRadius.circular(SpacingTokens.cardRadius),
            border: Border.all(color: c.line),
          ),
          child: Row(
            children: [
              Icon(
                title == 'Experience' ? Icons.work_rounded : Icons.code_rounded,
                color: c.accent,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: c.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: c.textTertiary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: c.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterCta extends StatelessWidget {
  const _FooterCta();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isWide = MediaQuery.sizeOf(context).width >= 800;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? SpacingTokens.xxl * 2 : SpacingTokens.lg,
        vertical: SpacingTokens.xxl * 1.5,
      ),
      color: c.bg2,
      child: Column(
        children: [
          Text(
            "Let's build something together.",
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: SpacingTokens.smd),
          Text(
            'Get in touch for collaborations or a friendly hello.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: c.textSecondary,
                ),
          ),
          const SizedBox(height: SpacingTokens.xxl),
          FilledButton(
            onPressed: () => router.go(RouteConstants.contact),
            child: const Text('Get in touch'),
          ),
        ],
      ),
    );
  }
}
