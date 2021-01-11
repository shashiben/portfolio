import 'package:flutter/material.dart';

class SkillModel {
  final String name;
  final int percent;

  SkillModel({@required this.name, @required this.percent});
}

List<SkillModel> skillList = [
  SkillModel(name: "Python", percent: 90),
  SkillModel(name: "Java", percent: 80),
  SkillModel(name: "C", percent: 70),
  SkillModel(name: "Node js", percent: 80),
  SkillModel(name: "Flutter", percent: 90),
  SkillModel(name: "Javascript", percent: 80)
];
