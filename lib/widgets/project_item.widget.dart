import 'package:flutter/material.dart';

import '../core/models/project.model.dart';
import 'components/gradient_title_placeholder.dart';

class ProjectItem extends StatefulWidget {
  final Project project;
  const ProjectItem({
    super.key,
    required this.project,
  });

  @override
  State<ProjectItem> createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 250,
        child: widget.project.image != null && widget.project.image!.isNotEmpty
            ? Image.asset(
                widget.project.image!,
                height: 250,
                fit: BoxFit.cover,
              )
            : GradientTitlePlaceholder(
                title: widget.project.name,
                aspectRatio: 16 / 9,
              ),
      );
}
