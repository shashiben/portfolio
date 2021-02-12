import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/core/utils/architecture_view.dart';
import 'package:portfolio/ui/views/main/main_view_model.dart';

class MainView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ac = useAnimationController();

    return ScreenBuilder<MainViewModel>(
      onModelReady: (m) => m.init(),
      viewModel: MainViewModel(),
      builder: (context, uiHelpers, model) => Scaffold(
        body: !model.isIntroCompleted
            ? Center(
                child: Lottie.asset(
                  "assets/illustrations/welcome.json",
                  controller: ac,
                  onLoaded: (composition) {
                    ac.addStatusListener((status) {
                      if (status == AnimationStatus.completed) {
                        model.changeIntroToCompleted();
                      }
                    });
                    ac
                      ..duration = composition.duration
                      ..forward();
                  },
                  repeat: false,
                ),
              )
            : CollapsibleSidebar(
                topPadding: 50,
                body: model.child,
                title: "Shashi Kumar",
                items: model.collapsibleItem),
      ),
    );
  }
}
