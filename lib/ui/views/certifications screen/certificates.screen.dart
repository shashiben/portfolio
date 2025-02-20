import 'dart:math';

import 'package:dev_utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/components/keyboard_listener.dart';
import 'certificate.view_model.dart';

class CertificationScreen extends StackedView<CertificateItemViewModel> {
  const CertificationScreen({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, CertificateItemViewModel viewModel, Widget? child) {
    return FullscreenKeyboardListener(
      onKeyDown: (event) => viewModel.handleKeyDown(event.logicalKey),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: max(1, context.width ~/ 400),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: viewModel.photoIds.length,
        itemBuilder: (context, index) {
          final bool isSelected = viewModel.index == index;
          return RepaintBoundary(
            child: GestureDetector(
              onTap: () => viewModel.setIndex(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  border: isSelected
                      ? Border.all(color: Colors.blue, width: 4)
                      : null,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: "https://picsum.photos/id/$index/200/300",
                      image: viewModel.photoIds[index],
                      fit: BoxFit.cover,
                    ),
                    AnimatedOpacity(
                      opacity: isSelected ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void onViewModelReady(CertificateItemViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  CertificateItemViewModel viewModelBuilder(BuildContext context) {
    return CertificateItemViewModel();
  }
}

class _AnimatedCutoutOverlay extends StatelessWidget {
  const _AnimatedCutoutOverlay({
    required this.child,
    required this.cutoutSize,
    required this.animationKey,
    this.duration,
    required this.swipeDir,
    required this.opacity,
    required this.enabled,
  });
  final Widget child;
  final Size cutoutSize;
  final Key animationKey;
  final Offset swipeDir;
  final Duration? duration;
  final double opacity;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Stack(
      children: [
        child,
        IgnorePointer(
            child: Container(color: Colors.black.withOpacity(opacity))),
      ],
    );
  }
}