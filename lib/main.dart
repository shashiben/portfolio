import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'app/theme/app_theme.dart';
import 'core/services/theme_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  try {
    await RiveNative.init();
  } on Object catch (_) {
    assert(true);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    _themeService = locator.get<ThemeService>();
    _themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      title: 'Portfolio',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeService.flutterThemeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
