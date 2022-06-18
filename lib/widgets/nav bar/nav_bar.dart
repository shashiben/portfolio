import 'package:flutter/material.dart';

class NextNavBar extends StatelessWidget {
  final Color? backgroundColor;
  final BoxDecoration? backgroundDecoration;
  final Widget? header;
  final EdgeInsets padding;

  const NextNavBar({
    Key? key,
    this.backgroundColor,
    this.header,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    this.backgroundDecoration,
  })  : assert(
          backgroundColor == null || backgroundDecoration == null,
          'Cannot provide both a color and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: color)".',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        return Container(
          width: maxWidth,
          padding: padding,
          decoration: backgroundDecoration,
          color: backgroundColor,
          child: Row(
            children: [header ?? const SizedBox()],
          ),
        );
      },
    );
  }
}
