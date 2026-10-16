import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/app.locator.dart';
import '../app/constants/data/my_info.data.dart';
import '../app/theme/app_theme_colors.dart';
import '../core/services/url_launcher_service.dart';
import 'fx/fx.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  static const List<(String, String)> _links = [
    ('GitHub', MYInfo.github),
    ('LinkedIn', MYInfo.linkedIn),
    ('Medium', MYInfo.medium),
    ('StackOverflow', MYInfo.stackOverflow),
    ('Instagram', MYInfo.instagram),
    ('Twitter', MYInfo.twitter),
    ('Telegram', MYInfo.telegram),
    ('WhatsApp', MYInfo.whatsappLink),
    ('Email', 'mailto:${MYInfo.email}'),
  ];

  static Path _energyLine(Size s) => Path()
    ..moveTo(0, s.height / 2)
    ..lineTo(s.width, s.height / 2);

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final mono = GoogleFonts.jetBrainsMono();
    final urlLauncher = locator<UrlLauncherService>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrambleText(
            'Thanks for stopping by.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 24,
            width: 160,
            child: LineDraw(
              pathBuilder: _energyLine,
              loop: true,
              strokeWidth: 1.5,
              duration: const Duration(milliseconds: 1800),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (final (label, url) in _links)
                TextButton(
                  onPressed: () => urlLauncher.open(url),
                  style: TextButton.styleFrom(foregroundColor: c.textSecondary),
                  child: Text(label, style: mono.copyWith(fontSize: 13)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(MYInfo.name, style: mono.copyWith(fontSize: 12, color: c.textTertiary)),
        ],
      ),
    );
  }
}
