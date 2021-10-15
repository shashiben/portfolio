import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final double thickness;
  final Color? dividerColor;
  final double radius;
  final double width;

  const DividerWidget(
      {Key? key,
      this.thickness = 2.0,
      required this.dividerColor,
      this.radius = 6,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: dividerColor,
            radius: radius,
          ),
          Expanded(
            child: Divider(
              color: dividerColor,
              thickness: thickness,
            ),
          )
        ],
      ),
    );
  }
}
