part of 'work_screen.dart';

class WorkScreenViewModel extends BaseViewModel {
  List<Project> get projects => projectsList;

  List<BlogItem> get blogs => blogList;

  void open(String url) => locator.get<UrlLauncherService>().open(url);
}
