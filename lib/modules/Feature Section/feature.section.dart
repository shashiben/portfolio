import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';

import '../../app/constants/data.dart';
import '../../core/models/feature-item.model.dart';
import '../../widgets/skill-item.widget.dart';

class FeatureSection extends StatelessWidget {
  const FeatureSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.height * 0.1),
      padding: EdgeInsets.symmetric(
          horizontal: context.isMobile ? 20 : context.width * 0.05),
      child: NextRow(
          verticalSpacing: 30,
          children: featuresList
              .map((FeatureModel e) => NextCol(
                    sizes: 'col-12 col-lg-3 col-md-6 col-xs-12 col-sm-6',
                    child: FeatureItem(
                      feature: e,
                    ).zoom(
                        viewPort: 0.28,
                        duration: const Duration(milliseconds: 300)),
                  ))
              .toList()),
    );
  }
}
