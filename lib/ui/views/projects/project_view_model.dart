import 'package:portfolio/app/configs.dart';
import 'package:portfolio/ui/widgets/grid_view_widget.dart';
import 'package:portfolio/ui/widgets/projectWidget.dart';
import 'package:stacked/stacked.dart';

class ProjectViewModel extends BaseViewModel {
  List<ResponsiveGridCol> list = [];
  init() {
    for (int i = 0; i < PersonalDetails.projectsList.length; i++) {
      list.add(ResponsiveGridCol(
          xl: 4,
          md: 6,
          child: ProjectWidget(
              index: i, project: PersonalDetails.projectsList[i])));
    }

    notifyListeners();
  }
}
