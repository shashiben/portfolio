import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../app/constants/data/my_info.data.dart';
import '../../app/theme/app_motion.dart';
import '../../app/tokens/color_tokens.dart';
import '../fx/fx.dart';
import '../omnitrix/omnitrix.dart';

/// First-frame splash. Starts opaque so it matches the HTML loader, then
/// either dismisses (already seen) or plays a short intro.
class OmniBootOverlay extends StatefulWidget {
  const OmniBootOverlay({super.key});

  @override
  State<OmniBootOverlay> createState() => _OmniBootOverlayState();
}

class _OmniBootOverlayState extends State<OmniBootOverlay> with SingleTickerProviderStateMixin {
  static const String _prefKey = 'omni_boot_seen';
  static const Duration _fade = Duration(milliseconds: 220);

  final List<Timer> _timers = [];
  late final AnimationController _spin = AnimationController(vsync: this, duration: const Duration(seconds: 6));

  bool _visible = true;
  bool _play = false;
  bool _showName = false;
  bool _fading = false;
  bool _light = false;

  bool _useLight(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide < 600 || defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStart());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _light = _useLight(context);
    final spin = _visible && _play && _light && !AppMotion.reduceMotion(context);
    if (spin && !_spin.isAnimating) {
      _spin.repeat();
    } else if (!spin && _spin.isAnimating) {
      _spin.stop();
    }
  }

  void _hide() {
    if (_spin.isAnimating) _spin.stop();
    if (!mounted || !_visible) return;
    setState(() => _visible = false);
  }

  Future<void> _maybeStart() async {
    if (!mounted) return;
    if (AppMotion.reduceMotion(context)) {
      _hide();
      return;
    }
    final SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      _hide();
      return;
    }
    if (!mounted) return;
    if (prefs.getBool(_prefKey) ?? false) {
      _hide();
      return;
    }
    setState(() => _play = true);
    if (_light && !AppMotion.reduceMotion(context)) _spin.repeat();
    _timers
      ..add(
        Timer(const Duration(milliseconds: 420), () {
          if (mounted) setState(() => _showName = true);
        }),
      )
      ..add(Timer(const Duration(milliseconds: 1400), () => _dismiss(fade: true)));
  }

  void _dismiss({required bool fade}) {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
    _spin.stop();
    unawaited(SharedPreferences.getInstance().then((p) => p.setBool(_prefKey, true)).catchError((_) => false));
    if (!mounted || !_visible) return;
    setState(() {
      if (fade) {
        _fading = true;
      } else {
        _visible = false;
      }
    });
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _spin.dispose();
    super.dispose();
  }

  static Path _crossGrid(Size s) {
    final path = Path()
      ..moveTo(s.width / 2, 0)
      ..lineTo(s.width / 2, s.height)
      ..moveTo(0, s.height / 2)
      ..lineTo(s.width, s.height / 2);
    for (final f in const [0.25, 0.75]) {
      path
        ..moveTo(s.width * f, s.height * 0.35)
        ..lineTo(s.width * f, s.height * 0.65)
        ..moveTo(s.width * 0.35, s.height * f)
        ..lineTo(s.width * 0.65, s.height * f);
    }
    return path..addRect(Offset.zero & s);
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColorTokens.omniGreen);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _dismiss(fade: false),
      child: AnimatedOpacity(
        opacity: _fading ? 0 : 1,
        duration: _fade,
        onEnd: () {
          if (_fading && mounted) setState(() => _visible = false);
        },
        child: ColoredBox(
          color: ColorTokens.omniVoid,
          child: _play
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(dimension: _light ? 88 : 220, child: _mark()),
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 48,
                        child: _showName
                            ? _light
                                  ? Text(MYInfo.name, style: text)
                                  : ScrambleText(MYInfo.name, reshuffleOnHover: false, style: text)
                            : null,
                      ),
                    ],
                  ),
                )
              : const SizedBox.expand(),
        ),
      ),
    );
  }

  Widget _mark() {
    if (_light) {
      return RotationTransition(
        turns: _spin,
        child: const CustomPaint(painter: _BootRingPainter(), child: SizedBox.expand()),
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_showName)
          Positioned.fill(
            child: IgnorePointer(
              child: LineDraw(
                pathBuilder: _crossGrid,
                color: ColorTokens.omniGreen.withValues(alpha: 0.5),
                strokeWidth: 1,
                duration: const Duration(milliseconds: 700),
              ),
            ),
          ),
        const IgnorePointer(child: OmnitrixWidget(size: 180)),
      ],
    );
  }
}

class _BootRingPainter extends CustomPainter {
  const _BootRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 4;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = ColorTokens.omniGreen.withValues(alpha: 0.18);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = ColorTokens.omniGreen;
    canvas
      ..drawCircle(c, r, track)
      ..drawArc(Rect.fromCircle(center: c, radius: r), -math.pi / 2, math.pi * 0.7, false, arc);
  }

  @override
  bool shouldRepaint(covariant _BootRingPainter oldDelegate) => false;
}
