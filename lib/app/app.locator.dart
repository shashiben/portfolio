import 'package:get_it/get_it.dart';

import '../core/services/url_launcher_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<UrlLauncherService>(() => UrlLauncherService());
}
