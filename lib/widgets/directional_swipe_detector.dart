import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'dart:math';

class DirectionalSwipeViewModel extends BaseViewModel {
  Offset _startPosition = Offset.zero;
  Offset _endPosition = Offset.zero;
  bool _isSwiping = false;

  void startSwipe(Offset startPosition) {
    _isSwiping = true;
    _startPosition = _endPosition = startPosition;
    notifyListeners();
  }

  Offset? updateSwipe(Offset currentPosition, double threshold) {
    if (!_isSwiping) return null;

    _endPosition = currentPosition;
    final swipeDelta = _endPosition - _startPosition;
    final distance = swipeDelta.distance;

    if (distance >= max(threshold, 1)) {
      final normalizedDelta = swipeDelta / distance;
      final swipeDirection = Offset(
        normalizedDelta.dx.roundToDouble(),
        normalizedDelta.dy.roundToDouble(),
      );

      resetSwipe();
      return swipeDirection;
    }

    return null;
  }

  void resetSwipe() {
    _startPosition = _endPosition = Offset.zero;
    _isSwiping = false;
    notifyListeners();
  }
}

class DirectionalSwipeDetector extends StackedView<DirectionalSwipeViewModel> {
  const DirectionalSwipeDetector({
    super.key,
    required this.child,
    this.threshold = 50,
    required this.onSwipe,
  });

  final Widget child;
  final double threshold;
  final void Function(Offset direction)? onSwipe;

  @override
  Widget builder(
    BuildContext context,
    DirectionalSwipeViewModel viewModel,
    Widget? child,
  ) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) => viewModel.startSwipe(details.localPosition),
        onPanUpdate: (details) {
          final direction =
              viewModel.updateSwipe(details.localPosition, threshold);
          if (direction != null) {
            onSwipe?.call(direction);
          }
        },
        onPanCancel: () => viewModel.resetSwipe(),
        onPanEnd: (details) => viewModel.resetSwipe(),
        child: this.child,
      );

  @override
  DirectionalSwipeViewModel viewModelBuilder(BuildContext context) =>
      DirectionalSwipeViewModel();
}
