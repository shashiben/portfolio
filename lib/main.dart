import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // Keep the semantics tree on so screen readers and the browser element
  // picker can reach Flutter widgets (web paints to a canvas otherwise).
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 100);
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      title: 'Portfolio',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
