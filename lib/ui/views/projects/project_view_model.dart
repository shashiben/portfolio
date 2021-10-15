import 'package:stacked/stacked.dart';

import '../../../app/configs.dart';
import '../../widgets/grid_view_widget.dart';
import '../../widgets/projectWidget.dart';

class ProjectViewModel extends BaseViewModel {
  int index = 0;
  Map<String, List<ResponsiveGridCol>> mapList = {};
  changeIndex(int n) {
    index = n;
    notifyListeners();
  }

  List<String> knowTypes = ['Application', 'Website'];

  Map<int, String> typeList = {
    0: 'All',
    1: 'Application',
    2: 'Website',
    3: 'Others'
  };

  getProjects() {
    return mapList[typeList[index]!];
  }

  List<ResponsiveGridCol> list = [];
  init() {
    mapList['All'] = [];
    mapList['Others'] = [];
    for (int i = 0; i < PersonalDetails.projectsList.length; i++) {
      for (final String s in PersonalDetails.projectsList[i].type) {
        if (knowTypes.contains(s)) {
          if (mapList[s] == null) {
            mapList[s] = [
              ResponsiveGridCol(
                  xl: 4,
                  sm: 12,
                  md: 6,
                  child: ProjectWidget(
                      index: i, project: PersonalDetails.projectsList[i]))
            ];
          } else {
            mapList[s]!.add(ResponsiveGridCol(
                xl: 4,
                sm: 12,
                md: 6,
                child: ProjectWidget(
                    index: i, project: PersonalDetails.projectsList[i])));
          }
        } else {
          mapList['Others']!.add(ResponsiveGridCol(
              xl: 4,
              sm: 12,
              md: 6,
              child: ProjectWidget(
                  index: i, project: PersonalDetails.projectsList[i])));
        }
      }
      mapList['All']!.add(ResponsiveGridCol(
          xl: 4,
          md: 6,
          sm: 12,
          child: ProjectWidget(
              index: i, project: PersonalDetails.projectsList[i])));
    }
    notifyListeners();
  }
}
