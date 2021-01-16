import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUtils.dart';

class ProjectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UIHelpers uiHelpers = UIHelpers.fromContext(context);

    return Material(
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              "Face Mask Detection Using Flutter",
              style: uiHelpers.headline,
              textAlign: TextAlign.center,
            ),
            
          ],
        ),
      ),
    );
  }
}
