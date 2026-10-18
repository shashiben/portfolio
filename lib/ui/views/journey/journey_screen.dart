import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import '../../../app/constants/data/awards.data.dart';
import '../../../app/constants/data/certificates.data.dart';
import '../../../app/constants/data/experience.data.dart';
import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../core/models/company.model.dart';
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
  Widget builder(BuildContext context, JourneyScreenViewModel viewModel, Widget? child) {
    final c = context.appColors;
    final theme = Theme.of(context).textTheme;
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final hPad = wide ? 64.0 : 24.0;
    final companies = viewModel.companies;

    return SingleChildScrollView(
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
                    Row(
                      children: [
                        ScrambleText(
                          'Journey',
                          style: theme.displayMedium?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 16),
                        CountUp(
                          value: companies.length,
                          style: theme.titleLarge?.copyWith(color: c.accent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 12,
                      child: LineDraw(strokeWidth: 1, duration: AppMotion.long, pathBuilder: _horizontalRule),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Experience, awards, certificates',
                      style: theme.titleMedium?.copyWith(color: c.textSecondary),
                    ),
                    SizedBox(height: wide ? 56 : 36),
                    _Timeline(companies: companies, gutter: wide ? 40 : 24),
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
    );
  }

  @override
  JourneyScreenViewModel viewModelBuilder(BuildContext context) => JourneyScreenViewModel();
}

Path _verticalLine(Size size) => Path()
  ..moveTo(size.width / 2, 0)
  ..lineTo(size.width / 2, size.height);

Path _horizontalRule(Size size) => Path()
  ..moveTo(0, size.height / 2)
  ..lineTo(size.width, size.height / 2);
