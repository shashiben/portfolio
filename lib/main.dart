import 'package:flutter/material.dart';
import 'package:portfolio/modules/Show%20Case/screens/show_case.screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Portfolio',
      home: ShowCaseScreen(),
    );
  }
}
