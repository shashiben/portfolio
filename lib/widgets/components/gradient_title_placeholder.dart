import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/app_theme_colors.dart';

class GradientTitlePlaceholder extends StatelessWidget {
  const GradientTitlePlaceholder({
    super.key,
    required this.title,
    this.aspectRatio = 16 / 9,
    this.borderRadius,
    this.compact = false,
  });

  final String title;
  final double aspectRatio;
  final BorderRadius? borderRadius;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? const BorderRadius.vertical(top: Radius.circular(15));

    final gradientColors = isDark
        ? [
            c.bg2,
            c.bg2,
            c.accent.withAlpha(60),
            c.accent.withAlpha(90),
            c.bg2,
          ]
        : [
            c.bg2,
            c.accent.withAlpha(80),
            c.accent.withAlpha(120),
            c.accent.withAlpha(80),
            c.bg2,
          ];

    final textShaderColors =
        isDark ? [c.textPrimary, c.textPrimary.withAlpha(230)] : [c.textPrimary, c.textPrimary.withAlpha(240)];

    return ClipRRect(
      borderRadius: radius,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
              colors: gradientColors,
            ),
          ),
          alignment: Alignment.center,
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: textShaderColors,
            ).createShader(bounds),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: compact ? 2 : 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.orbitron(
                fontSize: compact ? 10 : 18,
                fontWeight: FontWeight.w700,
                letterSpacing: compact ? 0.5 : 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
