import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/constants/data/my_info.data.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../app/tokens/tokens.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../widgets/components/page_shell.dart';
import '../../../widgets/components/section_header.dart';

part 'contact_us_screen.viewmodel.dart';

class ContactUsScreen extends StackedView<ContactUsScreenViewModel> {
  const ContactUsScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    ContactUsScreenViewModel viewModel,
    Widget? child,
  ) {
    final c = context.appColors;
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final urlLauncher = locator.get<UrlLauncherService>();
    return SingleChildScrollView(
      child: PageShell(
        maxWidth: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpacingTokens.lg),
            const SectionHeader(
              title: 'Contact',
              subtitle: 'Get in touch for projects or a quick hello.',
            ),
            const SizedBox(height: SpacingTokens.xxl),
            Container(
              padding: const EdgeInsets.all(SpacingTokens.lg),
              decoration: BoxDecoration(
                color: c.bg2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Available for new projects. Reach out with a brief and timeline.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: c.textPrimary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),
            FilledButton.icon(
              onPressed: () => urlLauncher.open('mailto:${MYInfo.email}'),
              icon: const Icon(Icons.mail_outline_rounded, size: 20),
              label: const Text('Email me'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: SpacingTokens.xl),
            Divider(height: 1, color: c.line),
            const SizedBox(height: SpacingTokens.lg),
            Text(
              'Links',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: c.textTertiary,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: isWide ? 24 : 16,
              runSpacing: 12,
              children: [
                _LinkChip(
                  label: 'Email',
                  value: MYInfo.email,
                  onTap: () => urlLauncher.open('mailto:${MYInfo.email}'),
                ),
                _LinkChip(
                  label: 'GitHub',
                  value: 'github.com/shashiben',
                  onTap: () => urlLauncher.open(MYInfo.github),
                ),
                _LinkChip(
                  label: 'LinkedIn',
                  value: 'linkedin.com/in/shashi-kumar',
                  onTap: () => urlLauncher.open(MYInfo.linkedIn),
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.xl),
            Text(
              'Phone',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: c.textTertiary,
                  ),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => urlLauncher.open(
                  'tel:${MYInfo.phone.replaceAll(RegExp(r'[\s\-]'), '')}'),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  MYInfo.phone,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: c.accent,
                        decoration: TextDecoration.underline,
                        decorationColor: c.accent,
                      ),
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
  ContactUsScreenViewModel viewModelBuilder(BuildContext context) =>
      ContactUsScreenViewModel();
}

class _LinkChip extends StatelessWidget {
  const _LinkChip({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$label · ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: c.textTertiary,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: c.accent,
                      decoration: TextDecoration.underline,
                      decorationColor: c.accent,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
