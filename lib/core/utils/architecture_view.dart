import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'ScreenUiHelper.dart';

class ScreenBuilder<T extends BaseViewModel> extends StatelessWidget {
  final bool disposeViewModel;
  final bool isReactive;
  final Widget Function(BuildContext, ScreenUiHelper, T) builder;
  final T viewModel;
  final Function(T) onModelReady;

  ScreenBuilder(
      {Key key,
      this.builder,
      this.viewModel,
      this.disposeViewModel = true,
      this.onModelReady,
      this.isReactive = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUiHelper uiHelpers = ScreenUiHelper.fromContext(context);

    if (isReactive) {
      return ViewModelBuilder<T>.reactive(
          disposeViewModel: disposeViewModel,
          onModelReady: onModelReady ?? null,
          viewModelBuilder: () => viewModel,
          builder: (context, model, child) => SafeArea(
                child: Scaffold(
                    backgroundColor: uiHelpers.backgroundColor,
                    body: builder(context, uiHelpers, model)),
              ));
    } else {
      return ViewModelBuilder<T>.nonReactive(
          builder: (context, model, child) =>
              SafeArea(child: builder(context, uiHelpers, model)),
          disposeViewModel: disposeViewModel,
          onModelReady: onModelReady ?? null,
          viewModelBuilder: () => viewModel);
    }
  }
}
