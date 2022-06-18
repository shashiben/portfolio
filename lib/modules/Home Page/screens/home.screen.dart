import 'package:flutter/material.dart';
import 'package:portfolio/gen/assets.gen.dart';
import 'package:portfolio/widgets/nav%20bar/nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: NextNavBar(
          header: Assets.images.skLogo.image(),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        preferredSize: const Size(double.infinity, 60),
      ),
    );
  }
}
