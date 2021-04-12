import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';

class ExperienceChipWidget extends StatefulWidget {
  const ExperienceChipWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExperienceChipWidgetState createState() => _ExperienceChipWidgetState();
}

class _ExperienceChipWidgetState extends State<ExperienceChipWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelpers = ScreenUiHelper.fromContext(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onEnter: (event) => setState(() => isHovered = true),
        onExit: (event) => setState(() => isHovered = false),
        child: Neumorphic(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          style: NeumorphicStyle(
            shape: isHovered ? NeumorphicShape.convex : NeumorphicShape.flat,
            depth: isHovered ? 6 : -12,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            color: surfaceColor,
          ),
          duration: Duration(milliseconds: 300),
          child: Text(
            widget.title,
            style: uiHelpers.body.copyWith(
                color: isHovered ? primaryColor : textSecondaryColor,
                fontWeight: isHovered ? FontWeight.w500 : FontWeight.w300),
          ),
        ),
      ),
    );
  }
}
