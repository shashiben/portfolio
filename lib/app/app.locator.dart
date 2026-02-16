import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/services/theme_service.dart';
import '../core/services/url_launcher_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<ThemeService>(() => ThemeService());
  locator.registerLazySingleton<UrlLauncherService>(() => UrlLauncherService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
}
