import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/locator.dart';
import 'package:portfolio/app/snackbar_config.dart';

import 'package:flutter/material.dart';
import 'package:portfolio/app/theme.dart';
import 'ui/views/main/main_view.dart';

Future main() async {
  await setupLocator();
  setupSnackbarUi();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      title: "Shashi Kumar",
      debugShowCheckedModeBanner: false,
      home: MainView(),
      themeMode: ThemeMode.light,
      theme: neumorphicLightTheme,
      darkTheme: neumorphicDarkTheme,
    );
  }
}
