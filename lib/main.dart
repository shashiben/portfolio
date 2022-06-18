import 'package:flutter/material.dart';
import 'package:portfolio/modules/Home%20Page/screens/home.screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Portfolio',
      home: HomeScreen(),
    );
  }
}
