import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel();
  bool isIntroCompleted = false;

  changeIntroToCompleted() {
    isIntroCompleted = true;
    notifyListeners();
  }
}
