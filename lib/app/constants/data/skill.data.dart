import 'package:flutter/material.dart';
import '../../../core/models/skill.dart';
import '../../../gen/assets.gen.dart';

final List<Skill> skillList = <Skill>[
  Skill(
    title: 'Mobile Application Development',
    image: Assets.images.skill.android.path,
    color: const Color(0xFFE2A599),
  ),
  Skill(
    title: 'Full Stack Web Development',
    image: Assets.images.skill.web.path,
    color: const Color(0xFF5E57BB),
  ),
  Skill(
    title: 'AI/ML Engineering',
    image: Assets.images.skill.ml.path,
    color: const Color(0xFFE45447),
  ),
  Skill(
    title: 'Database Management',
    image: Assets.images.skill.backend.path,
    color: const Color(0xFFFFB300),
  ),
  Skill(
    title: 'Flutter · MERN · Python',
    image: Assets.images.skill.luffy.path,
    color: Colors.green,
  ),
];
