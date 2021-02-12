import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  bool isIntroCompleted = false;

  changeIntroToCompleted() {
    isIntroCompleted = true;
    notifyListeners();
  }
}
