import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/models/project.dart';
import 'package:stacked/stacked.dart';

class ProjectViewModel extends BaseViewModel {
  List<Project> projectList = [];
  init() {
    projectList = PersonalDetails.projectsList;
    notifyListeners();
  }
}
