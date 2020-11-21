import 'package:flutter/material.dart';
import 'package:portfolio/app/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shashi Kumar",
      debugShowCheckedModeBanner: false,
      home: Container(),
      theme: lightTheme(context),
    );
  }
}
