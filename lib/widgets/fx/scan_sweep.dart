import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';
import '../../app/tokens/color_tokens.dart';
import 'fx_common.dart';

/// One vertical omni-green scan the first time [replayToken] changes, and again on hover.
class ScanSweep extends StatefulWidget {
  const ScanSweep({super.key, required this.child, this.replayToken = 0});

  final Widget child;
  final int replayToken;

  @override
  State<ScanSweep> createState() => _ScanSweepState();
}

class _ScanSweepState extends State<ScanSweep> with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(vsync: this, duration: AppMotion.long);

  @override
  void didUpdateWidget(ScanSweep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.replayToken != widget.replayToken) _play();
  }

  void _play() {
    if (!mounted || fxReduceMotion(context)) return;
    _sweep.forward(from: 0);
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _play(),
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _ScanPainter(_sweep))),
          ),
        ],
      ),
    );
  }
}

class _ScanPainter extends CustomPainter {
  _ScanPainter(this.progress) : super(repaint: progress);

  final Animation<double> progress;
  final Paint _band = Paint();
  final Paint _core = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t <= 0 || t >= 1 || size.isEmpty) return;
    final y = size.height * Curves.easeInOut.transform(t);
    _band.color = ColorTokens.omniGreen.withValues(alpha: 0.14);
    _core.color = ColorTokens.omniGreen.withValues(alpha: 0.85);
    canvas.drawRect(Rect.fromLTWH(0, y - 8, size.width, 16), _band);
    canvas.drawRect(Rect.fromLTWH(0, y - 0.6, size.width, 1.2), _core);
  }

  @override
  bool shouldRepaint(covariant _ScanPainter oldDelegate) => oldDelegate.progress != progress;
}
