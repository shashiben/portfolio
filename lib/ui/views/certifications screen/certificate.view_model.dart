import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class CertificateItemViewModel extends BaseViewModel {
  static const int gridSize = 3;
  late final int imgCount = gridSize * gridSize;
  final List<String> photoIds = List.generate(
    gridSize * gridSize,
    (index) => "https://picsum.photos/id/$index/200/300",
  );
  int index = 0;

  void setIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < imgCount) {
      index = newIndex;
      notifyListeners();
    }
  }

  bool handleKeyDown(LogicalKeyboardKey key) {
    final keyActions = {
      LogicalKeyboardKey.arrowUp: -gridSize,
      LogicalKeyboardKey.arrowDown: gridSize,
      LogicalKeyboardKey.arrowRight: 1,
      LogicalKeyboardKey.arrowLeft: -1,
    };

    final action = keyActions[key];
    if (action == null) return false;

    final newIndex = index + action;

    if (isValidIndex(newIndex, key)) {
      setIndex(newIndex);
      return true;
    }
    return false;
  }

  bool isValidIndex(int newIndex, LogicalKeyboardKey key) {
    if (newIndex < 0 || newIndex >= imgCount) return false;

    final isRightSide = index % gridSize == gridSize - 1;
    final isLeftSide = index % gridSize == 0;

    if ((isRightSide && key == LogicalKeyboardKey.arrowRight) ||
        (isLeftSide && key == LogicalKeyboardKey.arrowLeft)) {
      return false;
    }
    return true;
  }

  Future<void> init() async {
    // Add any initialization logic here
  }
}
  