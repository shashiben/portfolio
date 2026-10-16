import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../app/constants/data/skill.data.dart';
import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../core/models/skill.dart';
import '../../../widgets/fx/fx.dart';

const List<(String, List<String>)> _skillGroups = [
  ('Languages', ['Kotlin', 'Java', 'Dart', 'Python', 'JS', 'TS', 'Swift']),
  ('Mobile', ['Flutter', 'Jetpack Compose', 'Appium']),
  ('Backend & web', ['Spring Boot', 'Flask', 'MERN Stack', 'Firebase']),
  ('Data & infra', ['Kafka', 'Redis', 'Datadog']),
  ('Craft & testing', ['Figma', 'JUnit', 'Swings']),
];

const String _fallbackGroup = 'Tools';

String _groupOf(String title) {
  for (final (name, members) in _skillGroups) {
    if (members.contains(title)) return name;
  }
  return _fallbackGroup;
}

double _wrapAngle(double a) {
  while (a > math.pi) {
    a -= 2 * math.pi;
  }
  while (a < -math.pi) {
    a += 2 * math.pi;
  }
  return a;
}

/// Interactive 3D sphere of skills orbiting an Omnitrix core.
class SkillGalaxy extends StatefulWidget {
  const SkillGalaxy({super.key});

  @override
  State<SkillGalaxy> createState() => _SkillGalaxyState();
}

class _SkillGalaxyState extends State<SkillGalaxy> with SingleTickerProviderStateMixin {
  static const Duration _autoScan = Duration(milliseconds: 2800);
  static const Duration _userHold = Duration(seconds: 6);
  static const double _nodeBox = 72;
  static const double _driftSpeed = 0.14;

  final List<Skill> _skills = skillList;
  late final List<String> _groupOfSkill = [for (final s in _skills) _groupOf(s.title)];
  late final List<String> _groups = [
    for (final (name, _) in _skillGroups)
      if (_groupOfSkill.contains(name)) name,
    if (_groupOfSkill.contains(_fallbackGroup)) _fallbackGroup,
  ];

  late final int _n = _skills.length;
  late final Float64List _bx = Float64List(_n);
  late final Float64List _by = Float64List(_n);
  late final Float64List _bz = Float64List(_n);
  late final Float64List _px = Float64List(_n);
  late final Float64List _py = Float64List(_n);
  late final Float64List _pz = Float64List(_n);
  late final List<int> _order = List<int>.generate(_n, (i) => i);
  late final List<Widget> _icons = [for (final s in _skills) _SkillIcon(image: s.image, size: 24)];

  final ValueNotifier<int> _frame = ValueNotifier(0);
  final ValueNotifier<int> _selected = ValueNotifier(0);
  final ValueNotifier<String?> _group = ValueNotifier(null);

  late final Ticker _ticker = createTicker(_tick);
  Duration _last = Duration.zero;
  Timer? _scanTimer;
  DateTime _holdUntil = DateTime.fromMillisecondsSinceEpoch(0);

  double _yaw = 0.4;
  double _pitch = -0.25;
  double _velocity = 0;
  bool _focusing = true;
  bool _dragging = false;
  bool _hovering = false;
  bool _visible = false;
  bool _reduce = false;

  @override
  void initState() {
    super.initState();
    const golden = 2.399963229728653;
    for (var i = 0; i < _n; i++) {
      final y = 1 - (i + 0.5) * 2 / _n;
      final r = math.sqrt(1 - y * y);
      final t = i * golden;
      _bx[i] = math.cos(t) * r;
      _by[i] = y;
      _bz[i] = math.sin(t) * r;
    }
    _project();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduce = AppMotion.reduceMotion(context);
    if (_reduce) _snapTo(_selected.value);
    _sync();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scanTimer?.cancel();
    _frame.dispose();
    _selected.dispose();
    _group.dispose();
    super.dispose();
  }

  void _sync() {
    final run = _visible && !_reduce;
    if (run && !_ticker.isActive) {
      _last = Duration.zero;
      _ticker.start();
    } else if (!run && _ticker.isActive) {
      _ticker.stop();
    }
    if (run && _scanTimer == null) {
      _scanTimer = Timer.periodic(_autoScan, (_) => _autoAdvance());
    } else if (!run) {
      _scanTimer?.cancel();
      _scanTimer = null;
    }
  }

  void _autoAdvance() {
    if (_dragging || _hovering || DateTime.now().isBefore(_holdUntil)) return;
    _select((_selected.value + 1) % _n, user: false);
  }

  void _select(int i, {required bool user}) {
    _selected.value = i;
    _focusing = true;
    _velocity = 0;
    if (user) _holdUntil = DateTime.now().add(_userHold);
    if (_reduce) _snapTo(i);
  }

  (double, double) _target(int i) {
    final x = _bx[i], y = _by[i], z = _bz[i];
    final yaw = math.atan2(-x, z);
    final z1 = math.sqrt(x * x + z * z);
    final pitch = math.atan2(y, z1).clamp(-0.7, 0.7);
    return (yaw, pitch);
  }

  void _snapTo(int i) {
    final (yaw, pitch) = _target(i);
    _yaw = yaw;
    _pitch = pitch;
    _project();
    _frame.value++;
  }

  void _tick(Duration elapsed) {
    final dt = ((elapsed - _last).inMicroseconds / 1e6).clamp(0.0, 0.05);
    _last = elapsed;
    if (!_dragging) {
      if (_focusing) {
        final (ty, tp) = _target(_selected.value);
        final dy = _wrapAngle(ty - _yaw);
        final dp = tp - _pitch;
        final k = 1 - math.exp(-dt * 4.5);
        _yaw += dy * k;
        _pitch += dp * k;
        if (dy.abs() < 0.002 && dp.abs() < 0.002) _focusing = false;
      } else {
        _yaw += (_velocity + (_hovering ? 0 : _driftSpeed)) * dt;
        _velocity *= math.exp(-dt * 2.5);
      }
    }
    _project();
    _frame.value++;
  }

  void _project() {
    final cy = math.cos(_yaw), sy = math.sin(_yaw);
    final cp = math.cos(_pitch), sp = math.sin(_pitch);
    for (var i = 0; i < _n; i++) {
      final x = _bx[i], y = _by[i], z = _bz[i];
      final x1 = x * cy + z * sy;
      final z1 = -x * sy + z * cy;
      _px[i] = x1;
      _py[i] = y * cp - z1 * sp;
      _pz[i] = y * sp + z1 * cp;
    }
    _order.sort((a, b) => _pz[a].compareTo(_pz[b]));
  }

  void _onPanStart(DragStartDetails _) {
    _dragging = true;
    _focusing = false;
    _velocity = 0;
    _holdUntil = DateTime.now().add(_userHold);
  }

  void _onPanUpdate(DragUpdateDetails d) {
    _yaw += d.delta.dx * 0.008;
    _pitch = (_pitch - d.delta.dy * 0.008).clamp(-0.9, 0.9);
    if (_reduce) {
      _project();
      _frame.value++;
    }
  }

  void _onPanEnd(DragEndDetails d) {
    _dragging = false;
    _velocity = (d.velocity.pixelsPerSecond.dx * 0.004).clamp(-4.0, 4.0);
  }

  void _onGroupHover(String g, bool inside) {
    if (inside) {
      _group.value = g;
    } else if (_group.value == g) {
      _group.value = null;
    }
  }

  void _onGroupTap(String g) {
    _group.value = g;
    _select(_groupOfSkill.indexOf(g), user: true);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 800;
    final size = wide ? 480.0 : math.min(400.0, width - 48);

    final stage = VisibilityDetector(
      key: const ValueKey('skill-galaxy'),
      onVisibilityChanged: (info) {
        final v = info.visibleFraction > 0.05;
        if (v != _visible && mounted) {
          _visible = v;
          _sync();
        }
      },
      child: _stage(size),
    );

    final side = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _selected,
          builder: (context, i, _) => _ScanPanel(skill: _skills[i], group: _groupOfSkill[i], index: i, total: _n),
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder<String?>(
          valueListenable: _group,
          builder: (context, active, _) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final g in _groups)
                _GroupChip(
                  label: g,
                  count: _groupOfSkill.where((s) => s == g).length,
                  active: active == g,
                  onHover: (inside) => _onGroupHover(g, inside),
                  onTap: () => _onGroupTap(g),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Drag to spin  ·  tap a skill to scan',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.appColors.textTertiary),
        ),
      ],
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 340, child: side),
          const SizedBox(width: 32),
          Expanded(child: Center(child: stage)),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: stage),
        const SizedBox(height: 24),
        side,
      ],
    );
  }

  Widget _stage(double size) {
    return MouseRegion(
      onEnter: (_) => _hovering = true,
      onExit: (_) => _hovering = false,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: SizedBox.square(
          dimension: size,
          child: AnimatedBuilder(
            animation: Listenable.merge([_frame, _selected, _group]),
            builder: (context, _) => _scene(context, size),
          ),
        ),
      ),
    );
  }

  Widget _scene(BuildContext context, double size) {
    final c = context.appColors;
    final center = size / 2;
    final radius = size * 0.36;
    final sel = _selected.value;
    final group = _group.value;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _GalaxyPainter(
                yaw: _yaw,
                pitch: _pitch,
                px: _px,
                py: _py,
                pz: _pz,
                groupOfSkill: _groupOfSkill,
                selected: sel,
                group: group,
                radius: radius,
                accent: c.accent,
                line: c.line,
              ),
            ),
          ),
        ),
        for (final i in _order) _node(i, center, radius, sel, group),
      ],
    );
  }

  Widget _node(int i, double center, double radius, int sel, String? group) {
    final z = _pz[i];
    final persp = 2.6 / (2.6 - z);
    final depth = (z + 1) / 2;
    final scale = 0.55 + 0.6 * depth;
    final inGroup = group == null || _groupOfSkill[i] == group;
    final opacity = inGroup ? (0.25 + 0.75 * depth).clamp(0.0, 1.0) : 0.1;
    final dx = center + _px[i] * radius * persp;
    final dy = center + _py[i] * radius * persp;

    return Positioned(
      key: ValueKey(i),
      left: dx - _nodeBox / 2,
      top: dy - _nodeBox / 2,
      width: _nodeBox,
      height: _nodeBox,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: _GalaxyNode(
            icon: _icons[i],
            label: _skills[i].title,
            selected: i == sel,
            highlighted: group != null && inGroup,
            showLabel: depth > 0.72 || i == sel,
            onTap: () => _select(i, user: true),
          ),
        ),
      ),
    );
  }
}

class _GalaxyPainter extends CustomPainter {
  _GalaxyPainter({
    required this.yaw,
    required this.pitch,
    required this.px,
    required this.py,
    required this.pz,
    required this.groupOfSkill,
    required this.selected,
    required this.group,
    required this.radius,
    required this.accent,
    required this.line,
  });

  final double yaw;
  final double pitch;
  final Float64List px;
  final Float64List py;
  final Float64List pz;
  final List<String> groupOfSkill;
  final int selected;
  final String? group;
  final double radius;
  final Color accent;
  final Color line;

  static const int _ringSegments = 72;

  Offset _screen(Offset c, double x, double y, double z) {
    final persp = 2.6 / (2.6 - z);
    return c + Offset(x * radius * persp, y * radius * persp);
  }

  Path _ring(Offset c, double Function(double) fx, double Function(double) fy, double Function(double) fz) {
    final cy = math.cos(yaw), sy = math.sin(yaw);
    final cp = math.cos(pitch), sp = math.sin(pitch);
    final path = Path();
    for (var s = 0; s <= _ringSegments; s++) {
      final t = s / _ringSegments * 2 * math.pi;
      final x = fx(t), y = fy(t), z = fz(t);
      final x1 = x * cy + z * sy;
      final z1 = -x * sy + z * cy;
      final y1 = y * cp - z1 * sp;
      final z2 = y * sp + z1 * cp;
      final p = _screen(c, x1, y1, z2);
      s == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      c,
      radius * 1.32,
      stroke
        ..color = line
        ..strokeWidth = 1,
    );
    for (var k = 0; k < 60; k++) {
      final a = k / 60 * 2 * math.pi + yaw * 0.3;
      final major = k % 5 == 0;
      final r0 = radius * (major ? 1.25 : 1.28);
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(
        c + dir * r0,
        c + dir * radius * 1.32,
        stroke
          ..color = accent.withValues(alpha: major ? 0.45 : 0.18)
          ..strokeWidth = major ? 1.5 : 1,
      );
    }

    stroke
      ..color = accent.withValues(alpha: 0.14)
      ..strokeWidth = 1;
    canvas.drawPath(_ring(c, math.cos, (_) => 0, math.sin), stroke);
    canvas.drawPath(_ring(c, math.cos, math.sin, (_) => 0), stroke);
    canvas.drawPath(_ring(c, (_) => 0, math.sin, math.cos), stroke..color = accent.withValues(alpha: 0.08));

    final fill = Paint()..style = PaintingStyle.fill;
    canvas.drawCircle(c, radius * 0.34, fill..color = accent.withValues(alpha: 0.05));
    canvas.drawCircle(c, radius * 0.22, fill..color = accent.withValues(alpha: 0.09));
    final d = radius * 0.12;
    final diamond = Path()
      ..moveTo(c.dx, c.dy - d)
      ..lineTo(c.dx + d, c.dy)
      ..lineTo(c.dx, c.dy + d)
      ..lineTo(c.dx - d, c.dy)
      ..close();
    canvas.drawPath(diamond, fill..color = accent.withValues(alpha: 0.85));
    canvas.drawCircle(
      c,
      radius * 0.2,
      stroke
        ..color = accent.withValues(alpha: 0.5)
        ..strokeWidth = 1.5,
    );

    final g = group;
    if (g != null) {
      Offset? prev;
      for (var i = 0; i < px.length; i++) {
        if (groupOfSkill[i] != g) continue;
        final p = _screen(c, px[i], py[i], pz[i]);
        canvas.drawLine(
          c,
          p,
          stroke
            ..color = accent.withValues(alpha: 0.12)
            ..strokeWidth = 1,
        );
        if (prev != null) {
          canvas.drawLine(
            prev,
            p,
            stroke
              ..color = accent.withValues(alpha: 0.55)
              ..strokeWidth = 1.4,
          );
        }
        prev = p;
      }
    }

    final s = _screen(c, px[selected], py[selected], pz[selected]);
    final front = ((pz[selected] + 1) / 2).clamp(0.2, 1.0);
    canvas.drawLine(
      c,
      s,
      stroke
        ..color = accent.withValues(alpha: 0.18 * front)
        ..strokeWidth = 7,
    );
    canvas.drawLine(
      c,
      s,
      stroke
        ..color = accent.withValues(alpha: 0.9 * front)
        ..strokeWidth = 1.6,
    );
    canvas.drawCircle(
      s,
      30,
      stroke
        ..color = accent.withValues(alpha: 0.35 * front)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _GalaxyPainter old) => true;
}

class _GalaxyNode extends StatefulWidget {
  const _GalaxyNode({
    required this.icon,
    required this.label,
    required this.selected,
    required this.highlighted,
    required this.showLabel,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final bool selected;
  final bool highlighted;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  State<_GalaxyNode> createState() => _GalaxyNodeState();
}

class _GalaxyNodeState extends State<_GalaxyNode> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final lit = widget.selected || widget.highlighted || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppMotion.short,
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.selected ? Color.lerp(c.bg1, c.accent, 0.18) : c.bg1,
                border: Border.all(
                  color: lit ? c.accent : c.accent.withValues(alpha: 0.25),
                  width: widget.selected ? 2 : 1,
                ),
              ),
              child: widget.icon,
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 16,
              child: OverflowBox(
                maxWidth: 160,
                child: AnimatedOpacity(
                  duration: AppMotion.short,
                  opacity: widget.showLabel || _hover ? 1 : 0,
                  child: Text(
                    widget.label,
                    softWrap: false,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: lit ? c.accent : c.textSecondary, fontSize: 11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanPanel extends StatelessWidget {
  const _ScanPanel({required this.skill, required this.group, required this.index, required this.total});

  final Skill skill;
  final String group;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final text = Theme.of(context).textTheme;
    final counter = '${(index + 1).toString().padLeft(2, '0')} / ${total.toString().padLeft(2, '0')}';
    return HudFrame(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: AppMotion.short,
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: Tween<double>(begin: 0.6, end: 1).animate(CurvedAnimation(parent: anim, curve: AppMotion.spring)),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: Container(
              key: ValueKey(index),
              width: 68,
              height: 68,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.bg2,
                border: Border.all(color: c.accent, width: 1.5),
              ),
              child: _SkillIcon(image: skill.image, size: 36),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Scanning  $counter', style: text.labelSmall?.copyWith(color: c.accent, letterSpacing: 1.5)),
                const SizedBox(height: 6),
                ScrambleText(
                  skill.title,
                  key: ValueKey(index),
                  reshuffleOnHover: false,
                  style: text.headlineSmall?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(group, style: text.bodyMedium?.copyWith(color: c.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupChip extends StatelessWidget {
  const _GroupChip({
    required this.label,
    required this.count,
    required this.active,
    required this.onHover,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final ValueChanged<bool> onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.short,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: active ? c.accent.withValues(alpha: 0.12) : Colors.transparent,
            border: Border.all(color: active ? c.accent : c.line),
          ),
          child: Text(
            '$label  $count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: active ? c.accent : c.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _SkillIcon extends StatelessWidget {
  const _SkillIcon({required this.image, required this.size});

  final String image;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(Icons.code_rounded, size: size, color: context.appColors.textTertiary);
    if (image.startsWith('http')) {
      return SvgPicture.network(
        image,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => fallback,
      );
    }
    return Image.asset(image, width: size, height: size, fit: BoxFit.contain, errorBuilder: (_, _, _) => fallback);
  }
}
