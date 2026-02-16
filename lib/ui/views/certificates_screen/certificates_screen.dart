import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/constants/data/certificates.data.dart';
import '../../../app/constants/route_constants.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../app/tokens/tokens.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../widgets/components/page_shell.dart';
import '../../../widgets/components/section_header.dart';

part 'certificates_screen.viewmodel.dart';

class CertificatesScreen extends StackedView<CertificatesScreenViewModel> {
  const CertificatesScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    CertificatesScreenViewModel viewModel,
    Widget? child,
  ) {
    final c = context.appColors;
    return SingleChildScrollView(
      child: PageShell(
        maxWidth: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpacingTokens.lg),
            SectionHeader(
              title: 'Certifications',
              subtitle: 'Credentials and courses.',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => router.go(RouteConstants.about),
                style: IconButton.styleFrom(
                  foregroundColor: c.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),
            ...certificateList.map(
              (cert) => Padding(
                padding: const EdgeInsets.only(bottom: SpacingTokens.md),
                child: _CertificateCard(
                  item: cert,
                  onOpen: cert.url != null ? () => locator.get<UrlLauncherService>().open(cert.url!) : null,
                ),
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),
          ],
        ),
      ),
    );
  }

  @override
  CertificatesScreenViewModel viewModelBuilder(BuildContext context) => CertificatesScreenViewModel();
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.item, this.onOpen});
  final CertificateItem item;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: c.bg2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.accent.withAlpha(38),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.badge_outlined,
              color: c.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: c.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (item.issuer != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.issuer!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: c.textTertiary,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (onOpen != null)
            IconButton(
              icon: const Icon(Icons.open_in_new_rounded, size: 20),
              onPressed: onOpen,
              style: IconButton.styleFrom(
                foregroundColor: c.accent,
              ),
            ),
        ],
      ),
    );
  }
}
