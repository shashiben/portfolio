import 'app/theme.dart';
import 'package:flutter/material.dart';
import 'ui/views/main/main_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shashi Kumar",
      debugShowCheckedModeBanner: false,
      home: MainView(),
      theme: lightTheme(context),
    );
  }
}
