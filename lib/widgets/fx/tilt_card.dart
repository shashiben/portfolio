import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';
import 'fx_common.dart';

/// Pointer-follow 3D tilt with a glare highlight. Flat on narrow screens or with reduced motion.
class TiltCard extends StatefulWidget {
  const TiltCard({super.key, required this.child, this.maxTilt = 0.12, this.onTap});

  final Widget child;

  /// Maximum rotation in radians on each axis.
  final double maxTilt;
  final VoidCallback? onTap;

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> with SingleTickerProviderStateMixin {
  late final AnimationController _hover = AnimationController(vsync: this, duration: AppMotion.medium);
  late final Animation<double> _curved = CurvedAnimation(parent: _hover, curve: AppMotion.easeOut);

  /// Pointer position normalized to -1..1 on each axis.
  final ValueNotifier<Offset> _pointer = ValueNotifier<Offset>(Offset.zero);
  late final Listenable _repaint = Listenable.merge([_curved, _pointer]);

  void _onHover(PointerEvent e) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.isEmpty) return;
    final s = box.size;
    _pointer.value = Offset(
      (e.localPosition.dx / s.width * 2 - 1).clamp(-1.0, 1.0),
      (e.localPosition.dy / s.height * 2 - 1).clamp(-1.0, 1.0),
    );
  }

  @override
  void dispose() {
    _hover.dispose();
    _pointer.dispose();
    super.dispose();
  }

  Widget _tappable(Widget child) {
    if (widget.onTap == null) return child;
    return Semantics(
      button: true,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: widget.onTap, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flat = fxReduceMotion(context) || MediaQuery.sizeOf(context).width < 800;
    final cursor = widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer;
    if (flat) return MouseRegion(cursor: cursor, child: _tappable(widget.child));

    return MouseRegion(
      cursor: cursor,
      onEnter: (_) => _hover.forward(),
      onHover: _onHover,
      onExit: (_) => _hover.reverse(),
      child: _tappable(
        AnimatedBuilder(
          animation: _repaint,
          builder: (context, child) {
            final h = _curved.value;
            final p = _pointer.value;
            final m = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-p.dy * widget.maxTilt * h)
              ..rotateY(p.dx * widget.maxTilt * h);
            return Transform(alignment: Alignment.center, transform: m, child: child);
          },
          child: Stack(
            children: [
              RepaintBoundary(child: widget.child),
              Positioned.fill(
                child: IgnorePointer(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _GlarePainter(hover: _curved, pointer: _pointer, repaint: _repaint),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlarePainter extends CustomPainter {
  _GlarePainter({required this.hover, required this.pointer, required Listenable repaint})
    : _paint = Paint(),
      super(repaint: repaint);

  static const int _rings = 6;

  final Animation<double> hover;
  final ValueNotifier<Offset> pointer;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final h = hover.value;
    if (h <= 0 || size.isEmpty) return;
    final p = pointer.value;
    final center = Offset((p.dx + 1) / 2 * size.width, (p.dy + 1) / 2 * size.height);
    final radius = size.longestSide * 0.6;
    _paint.color = Colors.white.withValues(alpha: 0.022 * h);
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    for (var i = _rings; i > 0; i--) {
      canvas.drawCircle(center, radius * i / _rings, _paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GlarePainter old) => old.hover != hover || old.pointer != pointer;
}
