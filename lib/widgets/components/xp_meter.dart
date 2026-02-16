import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_motion.dart';

class XpMeter extends StatelessWidget {
  const XpMeter({
    super.key,
    required this.label,
    required this.value, // 0..1
    this.hint,
    this.color,
  }) : assert(value >= 0 && value <= 1);

  final String label;
  final double value;
  final String? hint;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.accentCyan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.textPrimary),
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 10,
            color: AppColors.bg2,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value),
              duration: AppMotion.medium,
              curve: AppMotion.easeOut,
              builder: (context, v, _) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: v,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          c.withValues(alpha: 0.45),
                          c.withValues(alpha: 0.95),
                          AppColors.accentBlue.withValues(alpha: 0.85),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: c.withValues(alpha: 0.22),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: 8),
          Text(
            hint!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ],
    );
  }
}
