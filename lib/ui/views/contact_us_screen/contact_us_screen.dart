import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/constants/data/my_info.data.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/fx/fx.dart';
import '../../../widgets/fx/fx_common.dart';

part 'contact_us_screen.viewmodel.dart';

class ContactUsScreen extends StackedView<ContactUsScreenViewModel> {
  const ContactUsScreen({super.key});

  @override
  Widget builder(BuildContext context, ContactUsScreenViewModel viewModel, Widget? child) {
    final c = context.appColors;
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 800;
    final mono = GoogleFonts.jetBrainsMono();
    final urlLauncher = locator<UrlLauncherService>();
    final tel = 'tel:${MYInfo.phone.replaceAll(RegExp(r'[\s\-]'), '')}';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wide ? 64 : 24, vertical: wide ? 64 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrambleText(
                  'Contact',
                  style: Theme.of(context).textTheme.displayMedium
                      ?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w700, fontSize: wide ? 48 : 36),
                ),
                const SizedBox(height: 32),
                if (wide)
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Reveal(child: _Terminal())),
                      SizedBox(width: 48),
                      Reveal(delay: Duration(milliseconds: 150), child: _SocialOrbit()),
                    ],
                  )
                else
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Reveal(child: _Terminal()),
                      SizedBox(height: 40),
                      Center(
                        child: Reveal(delay: Duration(milliseconds: 150), child: _SocialOrbit()),
                      ),
                    ],
                  ),
                const SizedBox(height: 40),
                Text('> voice line', style: mono.copyWith(color: c.textTertiary, fontSize: 12)),
                const SizedBox(height: 4),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => urlLauncher.open(tel),
                    child: Text(MYInfo.phone, style: mono.copyWith(color: c.textPrimary, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }

  @override
  ContactUsScreenViewModel viewModelBuilder(BuildContext context) => ContactUsScreenViewModel();
}

class _Terminal extends StatefulWidget {
  const _Terminal();

  @override
  State<_Terminal> createState() => _TerminalState();
}

class _TerminalState extends State<_Terminal> with SingleTickerProviderStateMixin {
  static const List<String> _lines = [
    '> link established',
    '> operator: ${MYInfo.name}',
    '> availability: open',
    '> channel: email',
  ];
  static const String _copyLabel = 'COPY EMAIL';
  static const String _glyphs = '01ΔΩ◇△§#';
  static final int _total = _lines.fold(0, (sum, l) => sum + l.length);

  late final AnimationController _blink = AnimationController(vsync: this, duration: const Duration(milliseconds: 530))
    ..repeat(reverse: true);
  Timer? _typer;
  final List<Timer> _copyTimers = [];
  int _typed = 0;
  String _label = _copyLabel;
  bool _started = false;

  void _start() {
    if (_started) return;
    _started = true;
    if (fxReduceMotion(context)) {
      setState(() => _typed = _total);
      return;
    }
    _typer = Timer.periodic(const Duration(milliseconds: 35), (t) {
      if (!mounted) return;
      setState(() => _typed++);
      if (_typed >= _total) t.cancel();
    });
  }

  Future<void> _copy() async {
    await Clipboard.setData(const ClipboardData(text: MYInfo.email));
    if (!mounted) return;
    for (final t in _copyTimers) {
      t.cancel();
    }
    _copyTimers.clear();
    final rnd = math.Random();
    setState(
      () => _label = String.fromCharCodes(
        List.generate(_copyLabel.length, (_) => _glyphs.codeUnitAt(rnd.nextInt(_glyphs.length))),
      ),
    );
    _copyTimers
      ..add(
        Timer(const Duration(milliseconds: 150), () {
          if (mounted) setState(() => _label = 'COPIED');
        }),
      )
      ..add(
        Timer(const Duration(milliseconds: 1350), () {
          if (mounted) setState(() => _label = _copyLabel);
        }),
      );
  }

  @override
  void dispose() {
    _typer?.cancel();
    for (final t in _copyTimers) {
      t.cancel();
    }
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final mono = GoogleFonts.jetBrainsMono(fontSize: 14, height: 1.7, color: c.textSecondary);
    final reduce = fxReduceMotion(context);

    var remaining = _typed;
    final visible = <String>[];
    for (final line in _lines) {
      if (remaining <= 0) break;
      visible.add(line.substring(0, math.min(remaining, line.length)));
      remaining -= line.length;
    }
    final done = _typed >= _total;

    final caret = FadeTransition(
      opacity: reduce ? const AlwaysStoppedAnimation(1.0) : _blink,
      child: Container(width: 9, height: 16, color: c.accent),
    );

    return FxVisibility(
      onShow: _start,
      child: HudFrame(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < _lines.length; i++)
              Row(
                children: [
                  Flexible(child: Text(i < visible.length ? visible[i] : '', style: mono)),
                  if (!done && i == math.max(0, visible.length - 1)) caret,
                ],
              ),
            const SizedBox(height: 12),
            AnimatedOpacity(
              opacity: done ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: SelectableText(
                          MYInfo.email,
                          style: mono.copyWith(color: c.accent, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (done) caret,
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _HudButton(label: _label, filled: true, onTap: _copy),
                      _HudButton(
                        label: 'OPEN MAIL',
                        onTap: () => locator<UrlLauncherService>().open('mailto:${MYInfo.email}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HudButton extends StatelessWidget {
  const _HudButton({required this.label, required this.onTap, this.filled = false});

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Semantics(
      button: true,
      label: label,
      child: MagneticButton(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 140),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: filled ? c.accent.withValues(alpha: 0.12) : null,
            border: Border.all(color: c.accent.withValues(alpha: filled ? 0.9 : 0.4)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.jetBrainsMono(color: c.accent, fontSize: 13, letterSpacing: 2),
          ),
        ),
      ),
    );
  }
}

class _SocialOrbit extends StatefulWidget {
  const _SocialOrbit();

  @override
  State<_SocialOrbit> createState() => _SocialOrbitState();
}

class _SocialOrbitState extends State<_SocialOrbit> with TickerProviderStateMixin {
  static const double _size = 280;
  static const double _radius = 112;
  static const double _node = 40;
  static const List<(String, String, String)> _nodes = [
    ('GH', 'GitHub', MYInfo.github),
    ('IN', 'LinkedIn', MYInfo.linkedIn),
    ('MD', 'Medium', MYInfo.medium),
    ('SO', 'StackOverflow', MYInfo.stackOverflow),
    ('IG', 'Instagram', MYInfo.instagram),
    ('X', 'Twitter', MYInfo.twitter),
    ('TG', 'Telegram', MYInfo.telegram),
    ('WA', 'WhatsApp', MYInfo.whatsappLink),
  ];

  late final AnimationController _spin = AnimationController(vsync: this, duration: const Duration(seconds: 20));
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  int? _hovered;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (fxReduceMotion(context)) {
      _spin.stop();
      _pulse.value = 0.5;
      _pulse.stop();
    } else {
      if (!_spin.isAnimating) _spin.repeat();
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Offset _pos(int i) {
    final a = _spin.value * 2 * math.pi + i * 2 * math.pi / _nodes.length - math.pi / 2;
    return Offset(_size / 2 + _radius * math.cos(a), _size / 2 + _radius * math.sin(a));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final urlLauncher = locator<UrlLauncherService>();
    return SizedBox.square(
      dimension: _size,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([_spin, _pulse]),
          builder: (context, _) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _OrbitPainter(
                      color: c.accent,
                      radius: _radius,
                      pulse: _pulse.value,
                      target: _hovered == null ? null : _pos(_hovered!),
                    ),
                  ),
                ),
                for (var i = 0; i < _nodes.length; i++)
                  Positioned(
                    left: _pos(i).dx - _node / 2,
                    top: _pos(i).dy - _node / 2,
                    child: Tooltip(
                      message: _nodes[i].$2,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => _hovered = i),
                        onExit: (_) => setState(() => _hovered = null),
                        child: GestureDetector(
                          onTap: () => urlLauncher.open(_nodes[i].$3),
                          child: AnimatedScale(
                            scale: _hovered == i ? 1.2 : 1,
                            duration: const Duration(milliseconds: 160),
                            child: Container(
                              width: _node,
                              height: _node,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: c.bg1,
                                border: Border.all(
                                  color: c.accent.withValues(alpha: _hovered == i ? 1 : 0.45),
                                  width: _hovered == i ? 1.5 : 1,
                                ),
                              ),
                              child: Text(
                                _nodes[i].$1,
                                style: GoogleFonts.jetBrainsMono(
                                  color: _hovered == i ? c.accent : c.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({required this.color, required this.radius, required this.pulse, this.target});

  final Color color;
  final double radius;
  final double pulse;
  final Offset? target;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = color.withValues(alpha: 0.18),
    );
    if (target != null) {
      canvas.drawLine(
        center,
        target!,
        Paint()
          ..strokeWidth = 4
          ..color = color.withValues(alpha: 0.15),
      );
      canvas.drawLine(
        center,
        target!,
        Paint()
          ..strokeWidth = 1.5
          ..color = color,
      );
    }
    final core = 22 + 4 * pulse;
    canvas.drawCircle(center, core + 14, Paint()..color = color.withValues(alpha: 0.06 + 0.06 * pulse));
    canvas.drawCircle(center, core + 6, Paint()..color = color.withValues(alpha: 0.14 + 0.1 * pulse));
    canvas.drawCircle(center, core, Paint()..color = color.withValues(alpha: 0.85));
    canvas.drawCircle(center, core * 0.4, Paint()..color = Color.lerp(color, Colors.white, 0.6)!);
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter old) =>
      old.pulse != pulse || old.target != target || old.color != color || old.radius != radius;
}
