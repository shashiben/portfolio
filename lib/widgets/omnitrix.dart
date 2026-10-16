import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/app.router.dart';
import '../app/constants/data/skill.data.dart';
import '../app/constants/route_constants.dart';
import '../app/theme/app_motion.dart';
import '../app/tokens/tokens.dart';
import 'fx/fx.dart';
import 'fx/fx_common.dart';
import 'painters/triangle.painter.dart';

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
  });

  final double? size;

  /// Defaults to [skillList].
  final List<OmniDialItem>? items;
  final OmnitrixMode mode;
  final ValueChanged<int>? onSelect;

  /// When set, the parent owns the full-screen flash; the dial only plays its local slam.
  final ValueChanged<int>? onTransform;

  @override
  State<OmnitrixWidget> createState() => _OmnitrixWidgetState();
}

class _OmnitrixWidgetState extends State<OmnitrixWidget> with TickerProviderStateMixin {
  static const _baseSize = 300.0;
  static const _minSize = 120.0;
  static const _maxSize = 400.0;
  static const _dockSize = 72.0;
  static const _tightWidth = 520.0;
  static const _calloutGap = 56.0;
  static const _panelWidth = 180.0;
  static const _calloutHeight = 120.0;
  static const _dragStepPx = 36.0;
  static const _menuNode = 44.0;
  static const _menuSlot = 72.0;

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
      if (!mounted || _reduceMotion) return;
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
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();
    if (_isDock) {
      return CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
          controller: _portal,
          overlayChildBuilder: (_) => _radialMenu(items, widget.size ?? _dockSize),
          child: _dial(items, widget.size ?? _dockSize),
        ),
      );
    }
    return LayoutBuilder(builder: (context, c) => _hero(items, c));
  }

  Widget _hero(List<OmniDialItem> items, BoxConstraints c) {
    final fixed = widget.size?.clamp(_minSize, _maxSize) ?? 0;
    if (widget.size != null) return _dial(items, fixed.toDouble());
    final tight = c.maxWidth < math.max(_tightWidth, fixed + _calloutGap + _panelWidth);
    final size = tight
        ? _heroSize(c.maxWidth, c.hasBoundedHeight ? c.maxHeight - _calloutHeight : double.infinity)
        : _heroSize(c.maxWidth - _calloutGap - _panelWidth, c.maxHeight);
    final dial = _dial(items, size);
    final panel = _callout(items[_index], items.length);
    if (tight) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          dial,
          SizedBox(
            width: 24,
            height: 32,
            child: LineDraw(key: ValueKey(_step), pathBuilder: _verticalLead, color: ColorTokens.omniGreen),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _panelWidth * 1.5),
            child: panel,
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dial,
        SizedBox(
          width: _calloutGap,
          height: 24,
          child: LineDraw(key: ValueKey(_step), pathBuilder: _horizontalLead, color: ColorTokens.omniGreen),
        ),
        SizedBox(width: _panelWidth, child: panel),
      ],
    );
  }

  static Path _horizontalLead(Size s) => Path()
    ..moveTo(0, s.height / 2)
    ..lineTo(s.width, s.height / 2)
    ..moveTo(s.width, s.height * 0.2)
    ..lineTo(s.width, s.height * 0.8);

  static Path _verticalLead(Size s) => Path()
    ..moveTo(s.width / 2, 0)
    ..lineTo(s.width / 2, s.height)
    ..moveTo(s.width * 0.2, s.height)
    ..lineTo(s.width * 0.8, s.height);

  Widget _callout(OmniDialItem item, int count) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: ColorTokens.omniPanel,
        border: Border.all(color: ColorTokens.omniGreen.withValues(alpha: 0.6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DNA ${(_index + 1).toString().padLeft(2, '0')}/${count.toString().padLeft(2, '0')}',
            style: text.labelSmall?.copyWith(color: ColorTokens.omniTextTertiary, letterSpacing: 2),
          ),
          const SizedBox(height: 4),
          ScrambleText(
            item.label,
            key: ValueKey(_step),
            style: text.titleMedium?.copyWith(
              color: ColorTokens.omniTextPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          if (item.subtitle != null) ...[
            const SizedBox(height: 2),
            Text(item.subtitle!, style: text.bodySmall?.copyWith(color: ColorTokens.omniTextSecondary)),
          ],
        ],
      ),
    );
  }

  Widget _dial(List<OmniDialItem> items, double size) {
    final scale = size / _baseSize;
    final node = SpacingTokens.omnitrixSmallRadius * scale;
    final inner = size - 2 * node;
    _dialSize = size;
    _innerSize = inner;
    final nodeWidget = _node(node, scale);
    final edge = (size - node) / 2;

    Widget dial = SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedRotation(
            turns: _step / items.length,
            duration: _reduceMotion ? Duration.zero : AppMotion.medium,
            curve: AppMotion.spring,
            child: RepaintBoundary(
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.square(size),
                    painter: _OuterRingPainter(innerRadius: inner / 2, glow: _shutter, glowSpread: 12 * scale),
                  ),
                  Positioned(top: 0, left: edge, child: nodeWidget),
                  Positioned(left: 0, top: edge, child: nodeWidget),
                  Positioned(right: 0, top: edge, child: nodeWidget),
                  Positioned(bottom: 0, left: edge, child: nodeWidget),
                ],
              ),
            ),
          ),
          _core(items[_index], inner, scale),
          IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(size: Size.square(size), painter: _ShockwavePainter(_shock, scale)),
            ),
          ),
          Positioned(left: 0, top: edge, width: node, height: node, child: _sideTap(() => _move(-1))),
          Positioned(right: 0, top: edge, width: node, height: node, child: _sideTap(() => _move(1))),
        ],
      ),
    );

    if (!_isDock) {
      dial = GestureDetector(onPanStart: _onPanStart, onPanUpdate: _onPanUpdate, onPanEnd: _onPanEnd, child: dial);
    }

    return FxVisibility(
      onShow: () {
        _visible = true;
        _syncIdle();
      },
      onHide: () {
        _visible = false;
        _syncIdle();
      },
      child: Focus(
        focusNode: _focus,
        onKeyEvent: _onKey,
        child: Semantics(
          button: true,
          label: _isDock ? 'Omnitrix menu: ${items[_index].label}' : 'Omnitrix: ${items[_index].label}',
          child: ScaleTransition(scale: _bounceScale, child: dial),
        ),
      ),
    );
  }

  Widget _sideTap(VoidCallback onTap) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap),
  );

  Widget _node(double node, double scale) => Container(
    width: node,
    height: node,
    padding: EdgeInsets.all(SpacingTokens.omnitrixRingPadding * scale),
    decoration: BoxDecoration(border: Border.all(), shape: BoxShape.circle, color: const Color(0xFF363636)),
    child: Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        ),
        FadeTransition(
          opacity: _glow,
          child: const DecoratedBox(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.greenAccent),
          ),
        ),
      ],
    ),
  );

  Widget _core(OmniDialItem item, double inner, double scale) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _onCoreTap,
        child: SizedBox.square(
          dimension: inner,
          child: Container(
            padding: EdgeInsets.all(SpacingTokens.omnitrixInnerPadding * scale),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            child: Container(
              padding: EdgeInsets.all(SpacingTokens.omnitrixRingPadding * scale),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Container(
                padding: EdgeInsets.all(SpacingTokens.omnitrixRingPadding * scale),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SpacingTokens.omnitrixBorderRadius * scale),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                        color: const Color(0xFF363636),
                        child: ClipPath(
                          clipper: DiamondClipper(),
                          child: ColoredBox(
                            color: Colors.black,
                            child: Padding(
                              padding: EdgeInsets.all(SpacingTokens.omnitrixContentPadding * scale),
                              child: ClipPath(
                                clipper: DiamondClipper(),
                                child: FadeTransition(
                                  opacity: _fadeOut,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      const ColoredBox(color: Colors.green),
                                      FadeTransition(
                                        opacity: _glow,
                                        child: ColoredBox(color: Colors.greenAccent.withValues(alpha: 0.6)),
                                      ),
                                      Center(
                                        child: RepaintBoundary(
                                          child: AnimatedSwitcher(
                                            duration: _reduceMotion ? Duration.zero : AppMotion.micro,
                                            child: KeyedSubtree(key: ValueKey(_step), child: _art(item, inner, scale)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _shutterBlade(Alignment.centerLeft, TriangleType.left, Colors.black),
                          _shutterBlade(Alignment.centerRight, TriangleType.right, Colors.black),
                        ],
                      ),
                      Column(
                        children: [
                          _shutterBlade(Alignment.topCenter, TriangleType.top, Colors.white),
                          _shutterBlade(Alignment.bottomCenter, TriangleType.bottom, Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shutterBlade(Alignment alignment, TriangleType type, Color color) => Expanded(
    child: IgnorePointer(
      child: ScaleTransition(
        alignment: alignment,
        scale: _shutterScale,
        child: ClipPath(
          clipper: TriangleClipperr(type: type),
          child: ColoredBox(color: color),
        ),
      ),
    ),
  );

  Widget _art(OmniDialItem item, double inner, double scale) {
    final image = item.image;
    final fallback = Icon(item.icon ?? Icons.code, size: inner / 3, color: Colors.black87);
    if (image == null) return fallback;
    if (_isNetworkUrl(image)) {
      return SvgPicture.network(
        image,
        fit: BoxFit.contain,
        height: 50 * scale,
        width: 50 * scale,
        placeholderBuilder: (_) => Icon(item.icon ?? Icons.code, size: 50 * scale, color: Colors.white70),
      );
    }
    return Image.asset(image, fit: BoxFit.contain, height: inner / 2, width: inner / 2);
  }

  Widget _radialMenu(List<OmniDialItem> items, double size) {
    final n = items.length;
    final radius = size / 2 + 64;
    final extent = radius + _menuSlot / 2;
    final spread = n < 6 ? math.pi * 0.8 : 2 * math.pi * (n - 1) / n;
    final labelStyle = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: ColorTokens.omniTextPrimary, letterSpacing: 1);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => _setOpen(false)),
        ),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.center,
          followerAnchor: Alignment.center,
          child: SizedBox.square(
            dimension: extent * 2,
            child: IgnorePointer(
              ignoring: !_open,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < n; i++)
                    _radialNode(
                      items[i],
                      i,
                      extent,
                      Offset.fromDirection(_facing - spread / 2 + (n == 1 ? spread / 2 : i * spread / (n - 1)), radius),
                      labelStyle,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _radialNode(OmniDialItem item, int i, double extent, Offset target, TextStyle? labelStyle) {
    final selected = i == _index;
    final image = item.image;
    final fg = selected ? Colors.black : ColorTokens.omniGreen;
    final art = image == null
        ? Icon(item.icon ?? Icons.circle, size: 20, color: fg)
        : _isNetworkUrl(image)
        ? SvgPicture.network(image, width: 22, height: 22)
        : Image.asset(image, width: 22, height: 22);

    return Positioned(
      left: extent - _menuSlot / 2,
      top: extent - _menuNode / 2,
      width: _menuSlot,
      child: AnimatedBuilder(
        animation: _menuT,
        builder: (context, child) => Transform.translate(
          offset: target * _menuT.value,
          child: Transform.scale(scale: 0.4 + 0.6 * _menuT.value, child: child),
        ),
        child: FadeTransition(
          opacity: _menu,
          child: Semantics(
            button: true,
            selected: selected,
            label: item.label,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _selectFromMenu(i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: _menuNode,
                      height: _menuNode,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? ColorTokens.omniGreen : ColorTokens.omniPanel,
                        border: Border.all(color: ColorTokens.omniGreen, width: 1.5),
                      ),
                      child: art,
                    ),
                    const SizedBox(height: 4),
                    ExcludeSemantics(
                      child: Text(item.label, style: labelStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
    onTransform: (i) => transformController.play(atPeak: () => router.go(_routes[i])),
  );
}

class _OuterRingPainter extends CustomPainter {
  _OuterRingPainter({required this.innerRadius, required this.glow, required this.glowSpread}) : super(repaint: glow);

  final double innerRadius;

  /// Shutter progress; the halo only exists while the shutter is moving.
  final Animation<double> glow;
  final double glowSpread;

  final Paint _fill = Paint()..color = const Color(0xFF363636);
  final Paint _stroke = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint _halo = Paint();
  Path? _ring;
  Size? _ringSize;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outerRadius = size.width / 2;

    final g = glow.value;
    if (g > 0) {
      _halo.color = Colors.greenAccent.withValues(alpha: 0.1 * g);
      canvas.drawCircle(center, outerRadius + glowSpread, _halo);
      _halo.color = Colors.greenAccent.withValues(alpha: 0.16 * g);
      canvas.drawCircle(center, outerRadius + glowSpread / 2, _halo);
    }

    if (_ringSize != size) {
      _ringSize = size;
      _ring = Path.combine(
        PathOperation.difference,
        Path()..addOval(Rect.fromCircle(center: center, radius: outerRadius)),
        Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius)),
      );
    }
    canvas
      ..drawPath(_ring!, _fill)
      ..drawPath(_ring!, _stroke);
  }

  @override
  bool shouldRepaint(covariant _OuterRingPainter old) =>
      old.innerRadius != innerRadius || old.glow != glow || old.glowSpread != glowSpread;
}

class _ShockwavePainter extends CustomPainter {
  _ShockwavePainter(this.t, this.scale) : super(repaint: t);

  final Animation<double> t;
  final double scale;
  final Paint _paint = Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final v = t.value;
    if (v <= 0 || v >= 1) return;
    final e = AppMotion.easeOut.transform(v);
    _paint
      ..strokeWidth = 1 + 6 * scale * (1 - e)
      ..color = ColorTokens.omniGreen.withValues(alpha: 1 - v);
    canvas.drawCircle(size.center(Offset.zero), e * size.width, _paint);
  }

  @override
  bool shouldRepaint(covariant _ShockwavePainter old) => old.t != t || old.scale != scale;
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width * 0.5, 0)
    ..lineTo(0, size.height * 0.5)
    ..lineTo(size.width * 0.5, size.height)
    ..lineTo(size.width, size.height * 0.5)
    ..lineTo(size.width * 0.5, 0)
    ..close();

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
