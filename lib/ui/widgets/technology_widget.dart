import 'package:flutter/material.dart';
import '../../core/models/technologies.dart';
import '../../core/utils/ScreenUiHelper.dart';

class TechnologyWidget extends StatelessWidget {
  final Technologies? technologies;

  const TechnologyWidget({Key? key, this.technologies}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            technologies!.icon,
            size: 25,
          ),
          Text(
            technologies!.name,
            style: uiHelper.title!
                .copyWith(color: uiHelper.textPrimaryColor, fontSize: 16),
          )
        ],
      ),
    );
  }
}
