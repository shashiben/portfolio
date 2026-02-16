import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_motion.dart';

/// Very subtle animated scanline overlay (minimal gaming feel).
///
/// Keep opacity low so the UI stays premium and clean.
class ScanlineOverlay extends StatefulWidget {
  const ScanlineOverlay({
    super.key,
    required this.child,
    this.enabled = true,
    this.opacity = 0.10,
    this.lineHeight = 120,
  });

  final Widget child;
  final bool enabled;
  final double opacity;
  final double lineHeight;

  @override
  State<ScanlineOverlay> createState() => _ScanlineOverlayState();
}

class _ScanlineOverlayState extends State<ScanlineOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = AppMotion.easeInOut.transform(_c.value);
        return Stack(
          children: [
            if (child != null) child,
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ScanlinePainter(
                    t: t,
                    opacity: widget.opacity,
                    lineHeight: widget.lineHeight,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  _ScanlinePainter({
    required this.t,
    required this.opacity,
    required this.lineHeight,
  });

  final double t;
  final double opacity;
  final double lineHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final y = (size.height + lineHeight) * t - lineHeight;
    final rect = Rect.fromLTWH(0, y, size.width, lineHeight);

    final grad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        AppColors.accentCyan.withValues(alpha: opacity * 0.55),
        AppColors.accentBlue.withValues(alpha: opacity),
        AppColors.accentCyan.withValues(alpha: opacity * 0.45),
        Colors.transparent,
      ],
      stops: const [0.0, 0.30, 0.52, 0.70, 1.0],
    );

    final paint = Paint()
      ..shader = grad.createShader(rect)
      ..blendMode = BlendMode.screen;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(rect, paint);

    // faint horizontal "phosphor" lines
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity * 0.05)
      ..strokeWidth = 1;

    const gap = 6.0;
    for (double ly = 0; ly < size.height; ly += gap) {
      final wobble = math.sin((ly / 80) + (t * math.pi * 2)) * 0.2;
      canvas.drawLine(
        Offset(0, ly + wobble),
        Offset(size.width, ly + wobble),
        linePaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.opacity != opacity ||
      oldDelegate.lineHeight != lineHeight;
}
