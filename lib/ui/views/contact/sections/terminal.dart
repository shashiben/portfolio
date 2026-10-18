part of '../contact_us_screen.dart';

class _Terminal extends StatefulWidget {
  const _Terminal({required this.onOpen});

  final ValueChanged<String> onOpen;

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
                      _HudButton(label: 'OPEN MAIL', onTap: () => widget.onOpen('mailto:${MYInfo.email}')),
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
