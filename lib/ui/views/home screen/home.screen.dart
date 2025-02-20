import 'package:flutter/material.dart';
import 'package:portfolio/widgets/omnitrix.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynMouseScroll(builder: (context, controller, physics) =>SingleChildScrollView(
      physics: physics,
      controller: controller,
      child: Column(children: [
        OmnitrixWidget()
      ],),
    ));
  }
}
