import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';

class HoverFx extends StatefulWidget {
  const HoverFx({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.hoverOnly = false,
    this.hoverScale = 1.02,
    this.pressScale = 0.98,
    this.hoverOffset = const Offset(0, -2),
    this.duration = AppMotion.short,
    this.curve = AppMotion.easeOut,
    this.mouseCursor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;

  /// When true, hover effects work even without [onTap].
  final bool hoverOnly;
  final double hoverScale;
  final double pressScale;
  final Offset hoverOffset;
  final Duration duration;
  final Curve curve;
  final MouseCursor? mouseCursor;

  @override
  State<HoverFx> createState() => _HoverFxState();
}

class _HoverFxState extends State<HoverFx> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;

  late final AnimationController _c;

  late Animation<Offset> _offsetAnim = const AlwaysStoppedAnimation(Offset.zero);
  late Animation<double> _scaleAnim = const AlwaysStoppedAnimation(1.0);

  Offset _offset = Offset.zero;
  double _scale = 1.0;

  bool get _supportsHover =>
      kIsWeb ||
      {
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
      }.contains(defaultTargetPlatform);

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _c.duration = widget.duration;
    _c.addListener(() {
      setState(() {
        _offset = _offsetAnim.value;
        _scale = _scaleAnim.value;
      });
    });
  }

  @override
  void didUpdateWidget(covariant HoverFx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _c.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _animateTo({required Offset offset, required double scale}) {
    _c.stop();
    final curved = CurvedAnimation(parent: _c, curve: widget.curve);
    _offsetAnim = Tween<Offset>(begin: _offset, end: offset).animate(curved);
    _scaleAnim = Tween<double>(begin: _scale, end: scale).animate(curved);
    _c.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled && (widget.onTap != null || widget.hoverOnly);
    final hovered = enabled && _supportsHover && _hovered;
    final pressed = enabled && _pressed;

    final targetScale = pressed ? widget.pressScale : (hovered ? widget.hoverScale : 1.0);
    final targetOffset = hovered ? widget.hoverOffset : Offset.zero;

    return MouseRegion(
      cursor: widget.onTap != null ? (widget.mouseCursor ?? SystemMouseCursors.click) : MouseCursor.defer,
      onEnter: (_) {
        setState(() => _hovered = true);
        _animateTo(offset: targetOffset, scale: targetScale);
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
          _pressed = false;
        });
        _animateTo(offset: Offset.zero, scale: 1.0);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? widget.onTap : null,
        onTapDown: enabled
            ? (_) {
                setState(() => _pressed = true);
                _animateTo(offset: targetOffset, scale: targetScale);
              }
            : null,
        onTapUp: enabled
            ? (_) {
                setState(() => _pressed = false);
                _animateTo(
                  offset: hovered ? widget.hoverOffset : Offset.zero,
                  scale: hovered ? widget.hoverScale : 1.0,
                );
              }
            : null,
        onTapCancel: enabled
            ? () {
                setState(() => _pressed = false);
                _animateTo(
                  offset: hovered ? widget.hoverOffset : Offset.zero,
                  scale: hovered ? widget.hoverScale : 1.0,
                );
              }
            : null,
        child: Transform.translate(
          offset: _offset,
          child: Transform.scale(
            scale: _scale,
            alignment: Alignment.center,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
