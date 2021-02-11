import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUtils.dart';

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
    final UIHelpers uiHelpers = UIHelpers.fromContext(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onEnter: (event) => setState(() => isHovered = true),
        onExit: (event) => setState(() => isHovered = false),
        child: AnimatedContainer(
          padding:
              EdgeInsets.symmetric(horizontal: 20, vertical: isHovered ? 8 : 5),
          decoration: BoxDecoration(
              color: isHovered
                  ? primaryColor.withOpacity(0.4)
                  : Colors.transparent,
              border: Border.all(
                  width: isHovered ? 2.5 : 1,
                  color: isHovered ? primaryColor : textSecondaryColor),
              borderRadius: BorderRadius.circular(12)),
          duration: Duration(milliseconds: 800),
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
