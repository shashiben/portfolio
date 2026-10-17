import 'package:flutter/widgets.dart';

import 'package:visibility_detector/visibility_detector.dart';

import '../../app/theme/app_motion.dart';

/// Safe to call above MaterialApp, where a MediaQuery may be absent.
bool fxReduceMotion(BuildContext context) => MediaQuery.maybeOf(context) != null && AppMotion.reduceMotion(context);

/// VisibilityDetector with a stable per-instance key.
class FxVisibility extends StatefulWidget {
  const FxVisibility({super.key, required this.child, this.onShow, this.onHide, this.threshold = 0.05});

  final Widget child;
  final VoidCallback? onShow;
  final VoidCallback? onHide;
  final double threshold;

  @override
  State<FxVisibility> createState() => _FxVisibilityState();
}

class _FxVisibilityState extends State<FxVisibility> {
  final Key _key = UniqueKey();
  bool _visible = false;

  void _onChanged(VisibilityInfo info) {
    if (!mounted) return;
    final visible = info.visibleFraction > widget.threshold;
    if (visible == _visible) return;
    _visible = visible;
    if (visible) {
      widget.onShow?.call();
    } else {
      widget.onHide?.call();
    }
  }

  @override
  Widget build(BuildContext context) =>
      VisibilityDetector(key: _key, onVisibilityChanged: _onChanged, child: widget.child);
}

/// Sizes itself to [sizing] while showing [display], so animated text never shifts layout.
class FxTextSlot extends StatelessWidget {
  const FxTextSlot({super.key, required this.sizing, required this.display, this.style});

  final String sizing;
  final String display;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Text(sizing, style: style),
        ),
        Positioned.fill(
          child: Text(display, style: style, softWrap: true, overflow: TextOverflow.clip),
        ),
      ],
    );
  }
}
