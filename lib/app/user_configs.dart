import 'package:flutter/material.dart';
import 'package:portfolio/core/models/skill_model.dart';

mixin UserConfigs {
  static List<SkillModel> skillList = [
    SkillModel(
        title: "App Developement",
        color: Colors.green,
        image: "assets/icons/android.svg",
        techList: ["Flutter", "Java", "Kotlin"]),
    SkillModel(
        title: "Web Developement",
        color: Colors.blue,
        image: "assets/icons/web.svg",
        techList: ["MERN Stack", "Html", "CSS"]),
    SkillModel(
        title: "Backend Developement",
        color: Colors.amber,
        image: "assets/icons/backend.svg",
        techList: ["Node Js", "Flask", "Firebase"]),
    SkillModel(
        title: "Others",
        color: Colors.orange,
        image: "assets/icons/others.svg",
        techList: ["OpenCV", "CNN"])
  ];
}
