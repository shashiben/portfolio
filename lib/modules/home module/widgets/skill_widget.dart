import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/core/models/skill_model.dart';

class SkillWidget extends HookWidget {
  final SkillModel skill;
  const SkillWidget({Key? key, required this.skill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaleController = useAnimationController(
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 200));
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: HoverWidget(builder: (context, isHovered) {
            if (isHovered) {
              scaleController.forward();
            } else {
              scaleController.reverse();
            }
            return ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.25).animate(scaleController),
              child: SvgPicture.asset(
                skill.image,
                color: skill.color,
                width: 35,
                height: 35,
              ),
            );
          }),
          decoration: BoxDecoration(
              color: const Color(0xFF2C2E44),
              borderRadius: BorderRadius.circular(12)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Text(
                skill.title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                skill.techList.join(", "),
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        )
      ],
    );
  }
}
