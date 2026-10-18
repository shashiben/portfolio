part of 'home_screen.dart';

class HomeScreenViewModel extends BaseViewModel {
  void openRoute(String path) {
    final cue = transformCue(path);
    transformController.play(style: cue.style, label: cue.label, atPeak: () => router.go(path));
  }
}
