import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DrawerText extends StatelessWidget {
  final Widget child;
  final bool isHovered;
  final double width;
  const DrawerText(
      {Key? key, required this.child, required this.isHovered, this.width = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
          AnimatedContainer(
            duration: Duration(milliseconds: 600),
            margin: EdgeInsets.only(top: 5),
            height: 3,
            width: isHovered ? width : 0,
            decoration: isHovered
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                        colors: [Color(0xFFfd6158), Color(0xFF050028)]))
                : BoxDecoration(),
          )
        ],
      ),
    );
  }
}

class HoverWidget extends HookWidget {
  final Widget child;
  final double width;
  const HoverWidget({Key? key, required this.child, this.width = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boolValue = useState(false);
    return MouseRegion(
      child: DrawerText(
        child: child,
        isHovered: boolValue.value,
        width: width,
      ),
      onEnter: (value) {
        boolValue.value = true;
      },
      onExit: (value) {
        boolValue.value = false;
      },
    );
  }
}
