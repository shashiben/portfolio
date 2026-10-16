import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/constants/data/awards.data.dart';
import '../../../app/constants/data/certificates.data.dart';
import '../../../app/constants/data/experience.data.dart';
import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../core/models/company.model.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/fx/fx.dart';

part 'journey_screen.viewmodel.dart';

class JourneyScreen extends StackedView<JourneyScreenViewModel> {
  const JourneyScreen({super.key});

  @override
  Widget builder(BuildContext context, JourneyScreenViewModel viewModel, Widget? child) => const _JourneyBody();

  @override
  JourneyScreenViewModel viewModelBuilder(BuildContext context) => JourneyScreenViewModel();
}

/// Current role first, then multi-role companies, then the rest in data order.
List<Company> _orderedCompanies() => [
  ...experienceList.where((c) => c.isCurrent),
  ...experienceList.where((c) => !c.isCurrent && c.subEntries.isNotEmpty),
  ...experienceList.where((c) => !c.isCurrent && c.subEntries.isEmpty),
];

Path _verticalLine(Size size) => Path()
  ..moveTo(size.width / 2, 0)
  ..lineTo(size.width / 2, size.height);

class _JourneyBody extends StatefulWidget {
  const _JourneyBody();

  @override
  State<_JourneyBody> createState() => _JourneyBodyState();
}

class _JourneyBodyState extends State<_JourneyBody> {
  final GlobalKey _timelineKey = GlobalKey();
  final ValueNotifier<double> _lineProgress = ValueNotifier<double>(0);
  final List<Company> _companies = _orderedCompanies();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateProgress());
  }

  @override
  void dispose() {
    _lineProgress.dispose();
    super.dispose();
  }

  /// Line is drawn down to the point 75% of the way down the viewport.
  void _updateProgress() {
    if (!mounted) return;
    if (AppMotion.reduceMotion(context)) {
      _lineProgress.value = 1;
      return;
    }
    final box = _timelineKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.height <= 0) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final reach = MediaQuery.sizeOf(context).height * 0.75 - top;
    _lineProgress.value = (reach / box.size.height).clamp(0.0, 1.0);
  }

  bool _onScroll(ScrollNotification n) {
    if (n.depth == 0 && n.metrics.axis == Axis.vertical) _updateProgress();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final theme = Theme.of(context).textTheme;
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final hPad = wide ? 64.0 : 24.0;

    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hPad, wide ? 64 : 32, hPad, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrambleText(
                        'Journey',
                        style: theme.displayMedium?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Experience, awards, certificates',
                        style: theme.titleMedium?.copyWith(color: c.textSecondary),
                      ),
                      SizedBox(height: wide ? 56 : 36),
                      _Timeline(
                        key: _timelineKey,
                        companies: _companies,
                        progress: _lineProgress,
                        gutter: wide ? 40 : 24,
                      ),
                      SizedBox(height: wide ? 80 : 56),
                      const _SectionLabel('Certificates'),
                      const SizedBox(height: 20),
                      const _CertificateStrip(),
                    ],
                  ),
                ),
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Row(
      children: [
        Container(width: 24, height: 2, color: c.accent),
        const SizedBox(width: 12),
        ScrambleText(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({super.key, required this.companies, required this.progress, required this.gutter});

  static const double _railWidth = 12;

  final List<Company> companies;
  final ValueNotifier<double> progress;
  final double gutter;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 6,
          bottom: 0,
          width: _railWidth,
          child: ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (context, value, _) => LineDraw(pathBuilder: _verticalLine, progress: value, color: c.accent),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < companies.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: i == companies.length - 1 ? 0 : 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 22),
                      child: Container(
                        width: _railWidth,
                        height: _railWidth,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.accent,
                          border: Border.all(color: c.bg0, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(width: gutter),
                    Expanded(
                      child: Reveal(
                        begin: Offset(i.isEven ? 0.08 : -0.08, 0),
                        child: _CompanyCard(company: companies[i]),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

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

class _AwardChip extends StatelessWidget {
  const _AwardChip({required this.award});

  final AwardItem award;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.accent.withValues(alpha: 0.08),
        border: Border.all(color: c.accent.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACHIEVEMENT UNLOCKED',
            style: theme.labelSmall?.copyWith(
              color: c.accent,
              fontSize: 9,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            award.name,
            style: theme.labelMedium?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ActiveBadge extends StatefulWidget {
  const _ActiveBadge();

  @override
  State<_ActiveBadge> createState() => _ActiveBadgeState();
}

class _ActiveBadgeState extends State<_ActiveBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
    lowerBound: 0.25,
    value: 1,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduceMotion(context)) {
      _blink
        ..stop()
        ..value = 1;
    } else if (!_blink.isAnimating) {
      _blink.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _blink.stop();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return FadeTransition(
      opacity: _blink,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: c.success),
          ),
          const SizedBox(width: 6),
          Text(
            'ACTIVE',
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: c.success, letterSpacing: 2, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _CertificateStrip extends StatelessWidget {
  const _CertificateStrip();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final theme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < certificateList.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            Builder(
              builder: (context) {
                final cert = certificateList[i];
                final url = cert.url;
                return SizedBox(
                  width: 220,
                  height: 150,
                  child: TiltCard(
                    onTap: url == null ? null : () => locator.get<UrlLauncherService>().open(url),
                    child: HudFrame(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (cert.issuer ?? 'CERT').toUpperCase(),
                            style: theme.labelSmall?.copyWith(color: c.accent, letterSpacing: 1.6),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              cert.name,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.titleSmall?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (url != null)
                            Text(
                              'VIEW ↗',
                              style: theme.labelSmall?.copyWith(color: c.textTertiary, letterSpacing: 1.4),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
