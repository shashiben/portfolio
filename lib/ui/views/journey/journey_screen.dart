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
import '../../../widgets/chrome/footer.dart';
import '../../../widgets/fx/fx.dart';

part 'journey_screen.viewmodel.dart';
part 'sections/timeline.dart';
part 'sections/company.dart';
part 'sections/awards.dart';
part 'sections/certificates.dart';

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
