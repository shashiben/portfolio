import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../app/app.router.dart';
import '../../app/constants/data/skill.data.dart';
import '../../app/constants/route_constants.dart';
import '../../app/theme/app_motion.dart';
import '../../app/tokens/tokens.dart';
import '../fx/fx.dart';
import '../fx/fx_common.dart';
import '../painters/triangle_painter.dart';

part 'omnitrix_build.dart';
part 'omnitrix_painters.dart';

bool _isNetworkUrl(String url) => url.startsWith('http://') || url.startsWith('https://');

class OmniDialItem {
  const OmniDialItem({required this.label, this.image, this.icon, this.subtitle});

  final String label;

  /// Asset path, or an http(s) url to an svg.
  final String? image;
  final IconData? icon;
  final String? subtitle;
}

enum OmnitrixMode { hero, dock }

class OmnitrixWidget extends StatefulWidget {
  const OmnitrixWidget({
    super.key,
    this.size,
    this.items,
    this.mode = OmnitrixMode.hero,
    this.onSelect,
    this.onTransform,
    this.spin,
  });

  final double? size;

  /// Defaults to [skillList].
  final List<OmniDialItem>? items;
  final OmnitrixMode mode;
  final ValueChanged<int>? onSelect;

  /// When set, the parent owns the full-screen flash; the dial only plays its local slam.
  final ValueChanged<int>? onTransform;

  /// Pulsed to 1 on slam so the 3D core can kick and burst. Parent owns it.
  final ValueNotifier<double>? spin;

  @override
  State<OmnitrixWidget> createState() => _OmnitrixWidgetState();
}

const double _baseSize = 300.0;
const double _minSize = 120.0;
const double _maxSize = 400.0;
const double _dockSize = 72.0;
const double _tightWidth = 520.0;
const double _calloutGap = 56.0;
const double _panelWidth = 180.0;
const double _calloutHeight = 120.0;
const double _dragStepPx = 36.0;
const double _menuNode = 44.0;

class _OmnitrixWidgetState extends State<OmnitrixWidget> with TickerProviderStateMixin {
  static final List<OmniDialItem> _skillItems = skillList
      .map((s) => OmniDialItem(label: s.title, image: s.image))
      .toList(growable: false);

  late final AnimationController _shutter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
    reverseDuration: const Duration(milliseconds: 800),
  );
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: Duration.zero,
    reverseDuration: const Duration(milliseconds: 1500),
  );
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  late final AnimationController _shock = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
  late final AnimationController _menu = AnimationController(vsync: this, duration: AppMotion.medium);

  late final Animation<double> _fadeOut = Tween<double>(begin: 1, end: 0).animate(_fade);
  late final Animation<double> _shutterScale = Tween<double>(begin: 0, end: 1).animate(_shutter);
  late final Animation<double> _glow = Tween<double>(
    begin: 0,
    end: 0.55,
  ).animate(CurvedAnimation(parent: _breath, curve: Curves.easeInOut));
  late final Animation<double> _bounceScale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.04).chain(CurveTween(curve: AppMotion.easeOut)), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.0).chain(CurveTween(curve: AppMotion.spring)), weight: 1),
  ]).animate(_bounce);
  late final Animation<double> _menuT = CurvedAnimation(
    parent: _menu,
    curve: AppMotion.spring,
    reverseCurve: AppMotion.easeOut,
  );

  final FocusNode _focus = FocusNode(debugLabel: 'Omnitrix');
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();

  /// Unwrapped so the ring never spins backwards across the last -> first wrap.
  int _step = 0;
  bool _open = false;
  bool _reduceMotion = false;
  bool _visible = false;
  bool _slamming = false;
  double _facing = -math.pi * 0.75;

  double _dialSize = _baseSize;
  double _innerSize = _baseSize;
  bool _dragOnRing = false;
  bool _dragMoved = false;
  double _dragAccum = 0;
  double? _lastAngle;

  List<OmniDialItem> get _items => widget.items ?? _skillItems;
  int get _index => _items.isEmpty ? 0 : _step % _items.length;
  bool get _isDock => widget.mode == OmnitrixMode.dock;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _reduceMotion || _isDock) return;
      final compact = MediaQuery.sizeOf(context).shortestSide < 600;
      if (compact || defaultTargetPlatform == TargetPlatform.iOS) return;
      _shutter.forward().then((_) => _shutter.reverse());
      _fade.forward().then((_) => _fade.reverse());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = AppMotion.reduceMotion(context);
    _syncIdle();
  }

  void _syncIdle() {
    if (!_reduceMotion && _visible) {
      if (!_breath.isAnimating) _breath.repeat(reverse: true);
    } else {
      _breath.value = 0;
    }
  }

  @override
  void dispose() {
    _shutter.dispose();
    _fade.dispose();
    _bounce.dispose();
    _breath.dispose();
    _shock.dispose();
    _menu.dispose();
    _focus.dispose();
    super.dispose();
  }

  int _shortestDelta(int target) {
    final n = _items.length;
    var d = (target - _index) % n;
    if (d > n / 2) d -= n;
    return d;
  }

  void _setStep(int step) {
    setState(() => _step = step);
    if (!_reduceMotion) _bounce.forward(from: 0);
  }

  void _move(int delta) {
    if (_items.length < 2 || delta == 0) return;
    _setStep(_step + delta);
    widget.onSelect?.call(_index);
  }

  Future<void> _slam() async {
    if (_slamming) return;
    _slamming = true;
    final i = _index;
    try {
      if (!_reduceMotion) {
        await _shutter.animateTo(1, duration: const Duration(milliseconds: 140), curve: AppMotion.easeOut).orCancel;
        if (!mounted) return;
        _shock.forward(from: 0);
        final spin = widget.spin;
        if (spin != null) {
          spin.value = 0;
          spin.value = 1;
        }
        _shutter.animateBack(0, duration: const Duration(milliseconds: 260), curve: AppMotion.easeOut);
      }
      widget.onTransform?.call(i);
    } on TickerCanceled {
      return;
    } finally {
      _slamming = false;
    }
  }

  void _onCoreTap() {
    _focus.requestFocus();
    if (_isDock) {
      _setOpen(!_open);
    } else {
      _slam();
    }
  }

  void _setOpen(bool open) {
    if (open == _open) return;
    if (open) _facing = _facingScreenCenter();
    setState(() => _open = open);
    if (open) {
      _portal.show();
      _reduceMotion ? _menu.value = 1 : _menu.forward();
    } else if (_reduceMotion) {
      _menu.value = 0;
      _portal.hide();
    } else {
      _menu.reverse().then((_) {
        if (mounted && !_open) _portal.hide();
      });
    }
  }

  double _facingScreenCenter() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return _facing;
    final screen = MediaQuery.sizeOf(context).center(Offset.zero);
    final v = screen - box.localToGlobal(box.size.center(Offset.zero));
    return v.distanceSquared < 1 ? _facing : v.direction;
  }

  void _selectFromMenu(int i) {
    _setOpen(false);
    if (i != _index) _setStep(_step + _shortestDelta(i));
    widget.onSelect?.call(i);
    _slam();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowRight) {
      _move(1);
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      _move(-1);
    } else if (event is KeyDownEvent && (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space)) {
      _onCoreTap();
    } else if (key == LogicalKeyboardKey.escape && _open) {
      _setOpen(false);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  void _onPanStart(DragStartDetails d) {
    _focus.requestFocus();
    final v = d.localPosition - Offset(_dialSize / 2, _dialSize / 2);
    _dragOnRing = v.distance > _innerSize / 2;
    _dragMoved = false;
    _dragAccum = 0;
    _lastAngle = null;
  }

  void _onPanUpdate(DragUpdateDetails d) {
    final n = _items.length;
    if (n < 2) return;
    int steps;
    if (_dragOnRing) {
      final a = (d.localPosition - Offset(_dialSize / 2, _dialSize / 2)).direction;
      if (_lastAngle != null) {
        var da = a - _lastAngle!;
        if (da > math.pi) da -= 2 * math.pi;
        if (da < -math.pi) da += 2 * math.pi;
        _dragAccum += da;
      }
      _lastAngle = a;
      final stepAngle = 2 * math.pi / n;
      steps = (_dragAccum / stepAngle).truncate();
      _dragAccum -= steps * stepAngle;
    } else {
      _dragAccum += d.delta.dx;
      final raw = (_dragAccum / _dragStepPx).truncate();
      _dragAccum -= raw * _dragStepPx;
      steps = -raw;
    }
    if (steps != 0) {
      _dragMoved = true;
      _move(steps);
    }
  }

  void _onPanEnd(DragEndDetails d) {
    if (_dragMoved || _dragOnRing) return;
    final v = d.velocity.pixelsPerSecond.dx;
    if (v < -100) {
      _move(1);
    } else if (v > 100) {
      _move(-1);
    }
  }

  double _heroSize(double maxW, double maxH) {
    if (widget.size != null) return widget.size!.clamp(_minSize, _maxSize);
    final limit = math.min(maxW, maxH);
    return limit.isFinite ? limit.clamp(_minSize, _maxSize) : _baseSize;
  }

  @override
  Widget build(BuildContext context) => _buildDial(context);
}

/// Dock-mode Omnitrix that navigates between the main sections.
class OmnitrixDock extends StatelessWidget {
  const OmnitrixDock({super.key});

  static const List<OmniDialItem> _items = [
    OmniDialItem(label: 'Home', icon: Icons.home_rounded),
    OmniDialItem(label: 'Journey', icon: Icons.timeline_rounded),
    OmniDialItem(label: 'Work', icon: Icons.folder_special_rounded),
    OmniDialItem(label: 'Contact', icon: Icons.alternate_email_rounded),
  ];

  static const List<String> _routes = [
    RouteConstants.home,
    RouteConstants.journey,
    RouteConstants.work,
    RouteConstants.contact,
  ];

  @override
  Widget build(BuildContext context) => OmnitrixWidget(
    mode: OmnitrixMode.dock,
    items: _items,
    onTransform: (i) {
      final cue = transformCue(_routes[i]);
      transformController.play(style: cue.style, label: cue.label, atPeak: () => router.go(_routes[i]));
    },
  );
}
