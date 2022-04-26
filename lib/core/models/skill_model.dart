import 'package:flutter/material.dart';

class SkillModel {
  final String title;
  final String image;
  final List<String> techList;
  final Color color;

  SkillModel(
      {required this.title,
      required this.image,
      required this.techList,
      required this.color});
}
