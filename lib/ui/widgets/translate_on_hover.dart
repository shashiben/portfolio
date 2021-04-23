import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TranslateOnHover extends HookWidget {
  final Widget child;

  TranslateOnHover({this.child});
  @override
  Widget build(BuildContext context) {
    final nonHoverTransform = Matrix4.identity();
    final hoverTransform = Matrix4.identity()..translate(0, -5, 0);
    var isHovered = useState(false);
    return MouseRegion(
      onEnter: (e) => isHovered.value = true,
      onExit: (e) => isHovered.value = false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: child,
        transform: isHovered.value ? hoverTransform : nonHoverTransform,
      ),
    );
  }
}
