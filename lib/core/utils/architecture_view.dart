import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'ScreenUtils.dart';

class ScreenBuilder<T extends BaseViewModel> extends StatelessWidget {
  final bool disposeViewModel;
  final bool isReactive;
  final Widget Function(BuildContext, UIHelpers, T) builder;
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
    UIHelpers uiHelpers = UIHelpers.fromContext(context);

    if (isReactive) {
      return ViewModelBuilder<T>.reactive(
          disposeViewModel: disposeViewModel,
          onModelReady: onModelReady ?? null,
          viewModelBuilder: () => viewModel,
          builder: (context, model, child) => SafeArea(
                      child: Scaffold(
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
