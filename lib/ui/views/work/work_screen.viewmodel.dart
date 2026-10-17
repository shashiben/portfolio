part of 'work_screen.dart';

class WorkScreenViewModel extends BaseViewModel {
  List<Project> get projects => projectsList;

  void open(String url) => locator.get<UrlLauncherService>().open(url);
}
