import 'package:flutter/material.dart';
import 'package:portfolio/core/models/skill.dart';
import 'package:portfolio/gen/assets.gen.dart';

final List<Skill> skillList = <Skill>[
  Skill(
    title: "App Developer",
    image: Assets.images.skill.android.path,
    color: Colors.green,
  ),
  Skill(
    title: "Web Developer",
    image: Assets.images.skill.web.path,
    color: Colors.green,
  ),
  Skill(
    title: "Backend\nDeveloper",
    image: Assets.images.skill.backend.path,
    color: Colors.green,
  ),
  Skill(
    title: "AI/ML\nDeveloper",
    image: Assets.images.skill.ml.path,
    color: Colors.green,
  ),
  Skill(
    title: "Best\nPartner✌",
    image: Assets.images.skill.luffy.path,
    color: Colors.green,
  )
];
