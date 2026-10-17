import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/app.locator.dart';
import '../../app/constants/data/my_info.data.dart';
import '../../app/theme/app_theme_colors.dart';
import '../../core/services/url_launcher_service.dart';
import '../fx/fx.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  static const List<(FaIconData, String, String)> _links = [
    (FontAwesomeIcons.github, 'GitHub', MYInfo.github),
    (FontAwesomeIcons.linkedin, 'LinkedIn', MYInfo.linkedIn),
    (FontAwesomeIcons.medium, 'Medium', MYInfo.medium),
    (FontAwesomeIcons.stackOverflow, 'Stack Overflow', MYInfo.stackOverflow),
    (FontAwesomeIcons.instagram, 'Instagram', MYInfo.instagram),
    (FontAwesomeIcons.xTwitter, 'Twitter', MYInfo.twitter),
    (FontAwesomeIcons.telegram, 'Telegram', MYInfo.telegram),
    (FontAwesomeIcons.whatsapp, 'WhatsApp', MYInfo.whatsappLink),
    (FontAwesomeIcons.envelope, 'Email', 'mailto:${MYInfo.email}'),
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
              for (final (icon, label, url) in _links)
                IconButton(
                  tooltip: label,
                  onPressed: () => urlLauncher.open(url),
                  icon: FaIcon(icon, size: 16),
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) return c.accent;
                      return c.textSecondary;
                    }),
                  ),
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
