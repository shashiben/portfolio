import 'package:portfolio/app/locator.dart';
import 'package:portfolio/app/snackbar_config.dart';

import 'app/theme.dart';
import 'package:flutter/material.dart';
import 'ui/views/main/main_view.dart';

Future main() async {
  await setupLocator();
  setupSnackbarUi();
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
