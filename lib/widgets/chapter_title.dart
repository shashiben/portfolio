import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_spacing.dart';

class ChapterTitle extends StatelessWidget {
  const ChapterTitle({
    super.key,
    required this.title,
    this.chapter,
    this.subtitle,
  });

  final String title;
  final String? chapter;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (chapter != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              chapter!,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.accentCyan,
                    letterSpacing: 1.2,
                  ),
            ),
          ),
        Text(
          title,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
