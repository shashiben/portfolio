// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/services/third_party_services.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final registerDependencies = _$RegisterDependencies();
  gh.lazySingleton<DialogService>(() => registerDependencies.dialogService);
  gh.lazySingleton<NavigationService>(
      () => registerDependencies.navigationService);
  gh.lazySingleton<SnackbarService>(() => registerDependencies.snackbarService);
  return get;
}

class _$RegisterDependencies extends RegisterDependencies {
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  SnackbarService get snackbarService => SnackbarService();
}
