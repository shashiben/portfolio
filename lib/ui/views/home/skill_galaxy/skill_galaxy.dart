import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../app/constants/data/skill.data.dart';
import '../../../../app/theme/app_motion.dart';
import '../../../../app/theme/app_theme_colors.dart';
import '../../../../core/models/skill.dart';
import '../../../../widgets/fx/fx.dart';

part 'galaxy_stage.dart';
part 'galaxy_painter.dart';
part 'galaxy_widgets.dart';

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

const double _nodeBox = 72;

class _SkillGalaxyState extends State<SkillGalaxy> with SingleTickerProviderStateMixin {
  static const Duration _autoScan = Duration(milliseconds: 2800);
  static const Duration _userHold = Duration(seconds: 6);
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
  Duration _lastPublish = Duration.zero;
  bool _coarse = false;
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
    _coarse = MediaQuery.sizeOf(context).shortestSide < 600 || defaultTargetPlatform == TargetPlatform.iOS;
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
    if (_coarse && _lastPublish != Duration.zero && elapsed - _lastPublish < const Duration(milliseconds: 33)) {
      return;
    }
    _lastPublish = elapsed;
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
    if (_reduce || _coarse) {
      _lastPublish = Duration.zero;
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
  Widget build(BuildContext context) => _layout(context);
}
