import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

@module
abstract class RegisterDependencies {
  @lazySingleton
  NavigationService get navigationService;

  @lazySingleton
  SnackbarService get snackbarService;

  @lazySingleton
  DialogService get dialogService;
}
