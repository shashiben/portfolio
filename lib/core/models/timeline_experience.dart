import 'package:flutter/material.dart';

class ExperienceTimeline {
  final String title;
  final String position;
  final List<String> description;
  final Widget child;
  final String timePeriod;
  final List<String> tools;

  const ExperienceTimeline(
      {@required this.title,
      @required this.position,
      @required this.timePeriod,
      @required this.description,
      @required this.child,
      @required this.tools});
}
