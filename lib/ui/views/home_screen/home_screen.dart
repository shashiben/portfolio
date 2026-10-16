import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.router.dart';
import '../../../app/constants/data/awards.data.dart';
import '../../../app/constants/data/education.data.dart';
import '../../../app/constants/data/my_info.data.dart';
import '../../../app/constants/route_constants.dart';
import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../gen/assets.gen.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/fx/fx.dart';
import '../../../widgets/omnitrix.dart';
import '../../../widgets/three_d/three_d.dart';
import 'skill_galaxy.dart';

part 'home_screen.viewmodel.dart';

const double _breakpoint = 800;

bool _isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= _breakpoint;

void _transformTo(String path) => transformController.play(atPeak: () => router.go(path));

class HomeScreen extends StackedView<HomeScreenViewModel> {
  const HomeScreen({super.key});

  @override
  Widget builder(BuildContext context, HomeScreenViewModel viewModel, Widget? child) {
    final pad = _isWide(context) ? 64.0 : 24.0;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: pad),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [_Hero(), _Origin(), _Roster(), _DnaRecord(), SizedBox(height: 96)],
                ),
              ),
              const SiteFooter(),
            ],
          ),
        ),
        const Positioned.fill(child: _BootOverlay()),
      ],
    );
  }

  @override
  HomeScreenViewModel viewModelBuilder(BuildContext context) => HomeScreenViewModel();
}

// ---------------------------------------------------------------------------
// Boot intro

class _BootOverlay extends StatefulWidget {
  const _BootOverlay();

  @override
  State<_BootOverlay> createState() => _BootOverlayState();
}

class _BootOverlayState extends State<_BootOverlay> {
  static const String _prefKey = 'omni_boot_seen';
  static const Duration _fade = Duration(milliseconds: 320);

  final List<Timer> _timers = [];
  bool _visible = false;
  bool _showName = false;
  bool _fading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStart());
  }

  Future<void> _maybeStart() async {
    if (!mounted || AppMotion.reduceMotion(context)) return;
    final SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      return;
    }
    if (!mounted || (prefs.getBool(_prefKey) ?? false)) return;
    setState(() => _visible = true);
    _timers
      ..add(
        Timer(const Duration(milliseconds: 600), () {
          if (mounted) setState(() => _showName = true);
        }),
      )
      ..add(Timer(const Duration(milliseconds: 1800) - _fade, () => _dismiss(fade: true)));
  }

  void _dismiss({required bool fade}) {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
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
    final c = context.appColors;
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
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_showName)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: LineDraw(
                              pathBuilder: _crossGrid,
                              color: c.accent.withValues(alpha: 0.5),
                              strokeWidth: 1,
                              duration: const Duration(milliseconds: 900),
                            ),
                          ),
                        ),
                      const IgnorePointer(child: OmnitrixWidget(size: 180)),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 48,
                  child: _showName
                      ? ScrambleText(
                          MYInfo.name,
                          reshuffleOnHover: false,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: c.accent),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared bits

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(top: 96, bottom: 32),
      child: Row(
        children: [
          Container(width: 8, height: 8, color: c.accent),
          const SizedBox(width: 12),
          ScrambleText(
            text,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 16),
          Expanded(child: Container(height: 1, color: c.accent.withValues(alpha: 0.2))),
        ],
      ),
    );
  }
}

class _HexClipper extends CustomClipper<Path> {
  const _HexClipper();

  @override
  Path getClip(Size size) => _hexPath(size);

  @override
  bool shouldReclip(covariant _HexClipper oldClipper) => false;
}

Path _hexPath(Size s) {
  final cx = s.width / 2, cy = s.height / 2;
  final r = math.min(s.width, s.height) / 2;
  final path = Path();
  for (var i = 0; i < 6; i++) {
    final a = -math.pi / 2 + i * math.pi / 3;
    final p = Offset(cx + r * math.cos(a), cy + r * math.sin(a));
    i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
  }
  return path..close();
}

class _HexBorderPainter extends CustomPainter {
  _HexBorderPainter({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _hexPath(Size(size.width - width, size.height - width)).shift(Offset(width / 2, width / 2)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _HexBorderPainter old) => old.color != color || old.width != width;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onTap, this.filled = false});

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return MagneticButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: filled ? c.accent : Colors.transparent,
          border: Border.all(color: c.accent),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: filled ? c.bg0 : c.accent, letterSpacing: 1.8, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final wide = _isWide(context);
    final text = Theme.of(context).textTheme;

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(MYInfo.designation, style: text.labelSmall?.copyWith(color: c.accent, letterSpacing: 2)),
        const SizedBox(height: 16),
        ScrambleText(
          'Building products that scale.',
          style: text.displayLarge?.copyWith(color: c.textPrimary, fontSize: wide ? 56 : 36, height: 1.08),
        ),
        const SizedBox(height: 20),
        EnergyStroke(
          child: Text(MYInfo.designation, style: text.titleLarge?.copyWith(color: c.textPrimary)),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Full-stack development. Mobile & web. Delivering impact through clean code and thoughtful design.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.bodyLarge?.copyWith(color: c.textSecondary, height: 1.5),
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _ActionButton(label: 'Get in touch', filled: true, onTap: () => _transformTo(RouteConstants.contact)),
            _ActionButton(label: 'View work', onTap: () => _transformTo(RouteConstants.work)),
          ],
        ),
      ],
    );

    final width = MediaQuery.sizeOf(context).width;
    final coreSize = wide ? 340.0 : math.min(340.0, width - 48);
    final dialSize = coreSize * 0.86;
    final device = SizedBox.square(
      dimension: coreSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          IgnorePointer(
            child: ClipOval(child: OmnitrixCore3D(size: dialSize)),
          ),
          OmnitrixWidget(size: dialSize),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(top: wide ? 96 : 48),
      child: wide
          ? Row(
              children: [
                Expanded(child: copy),
                const SizedBox(width: 48),
                device,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                copy,
                const SizedBox(height: 48),
                Center(child: device),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Origin

class _Origin extends StatelessWidget {
  const _Origin();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final wide = _isWide(context);

    final bio = Reveal(
      child: Text(
        MYInfo.aboutBodyText1,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: c.textSecondary, height: 1.7, fontSize: 18),
      ),
    );

    final stats = Wrap(
      spacing: 40,
      runSpacing: 24,
      children: [
        _Stat(value: DateTime.now().year - 2021, label: 'Years', suffix: '+'),
        const _Stat(value: 12, label: 'Apps shipped'),
        _Stat(value: awardList.length, label: 'Awards'),
      ],
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [bio, const SizedBox(height: 40), stats],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('About'),
        if (wide)
          Row(
            children: [
              const _HexAvatar(size: 220),
              const SizedBox(width: 56),
              Expanded(child: text),
              const SizedBox(width: 32),
              const IgnorePointer(child: DnaHelix(size: 140)),
            ],
          )
        else ...[
          const Center(child: _HexAvatar(size: 180)),
          const SizedBox(height: 32),
          text,
        ],
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.suffix = ''});

  final int value;
  final String label;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CountUp(
          value: value,
          suffix: suffix,
          style: text.displaySmall?.copyWith(color: c.accent),
        ),
        const SizedBox(height: 4),
        Text(label, style: text.labelSmall?.copyWith(color: c.textSecondary, letterSpacing: 2)),
      ],
    );
  }
}

class _HexAvatar extends StatefulWidget {
  const _HexAvatar({required this.size});

  final double size;

  @override
  State<_HexAvatar> createState() => _HexAvatarState();
}

class _HexAvatarState extends State<_HexAvatar> with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(vsync: this, duration: const Duration(seconds: 14));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduceMotion(context)) {
      _spin.stop();
    } else if (!_spin.isAnimating) {
      _spin.repeat();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final ring = widget.size + 36;
    return SizedBox.square(
      dimension: ring,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _spin,
            child: CustomPaint(size: Size.square(ring), painter: _ArcPainter(c.accent)),
          ),
          SizedBox.square(
            dimension: widget.size,
            child: CustomPaint(
              foregroundPainter: _HexBorderPainter(color: c.accent.withValues(alpha: 0.8), width: 2),
              child: ClipPath(
                clipper: const _HexClipper(),
                child: Image.asset(Assets.images.avatar.path, fit: BoxFit.cover, alignment: Alignment.topCenter),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..color = color;
    canvas
      ..drawArc(rect, 0, math.pi * 0.6, false, paint)
      ..drawArc(rect, math.pi, math.pi * 0.35, false, paint..color = color.withValues(alpha: 0.5));
    final inner = rect.deflate(8);
    canvas.drawArc(inner, math.pi * 0.4, math.pi * 0.25, false, paint..color = color.withValues(alpha: 0.3));
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) => old.color != color;
}

// ---------------------------------------------------------------------------
// Skills

class _Roster extends StatelessWidget {
  const _Roster();

  @override
  Widget build(BuildContext context) =>
      const Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [_SectionTitle('Skills'), SkillGalaxy()]);
}

// ---------------------------------------------------------------------------
// Education

class _DnaRecord extends StatelessWidget {
  const _DnaRecord();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('Education'),
        for (var i = 0; i < educationList.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Reveal(
              delay: Duration(milliseconds: 80 * i),
              child: HudFrame(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            educationList[i].period,
                            style: text.labelSmall?.copyWith(color: c.accent, letterSpacing: 1.6),
                          ),
                        ),
                        if (educationList[i].score != null)
                          Text(
                            educationList[i].score!,
                            style: text.labelSmall?.copyWith(color: c.accent, letterSpacing: 1.6),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(educationList[i].institution, style: text.titleMedium?.copyWith(color: c.textPrimary)),
                    const SizedBox(height: 4),
                    Text(educationList[i].degree, style: text.bodyMedium?.copyWith(color: c.textSecondary)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
