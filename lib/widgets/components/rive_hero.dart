import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../app/theme/app_colors.dart';

/// Optional Rive animation for hero section.
/// Loads from [fallbackUrl] by default. To use your own .riv:
/// 1. Add assets/rive/ to pubspec.yaml assets.
/// 2. Put your .riv file in assets/rive/ (e.g. hero.riv).
/// 3. Pass assetPath: 'assets/rive/hero.riv'.
class RiveHero extends StatefulWidget {
  const RiveHero({
    super.key,
    this.size = 280,
    this.fit = Fit.contain,
    this.assetPath,
    this.fallbackUrl = 'https://cdn.rive.app/animations/vehicles.riv',
  });

  final double size;
  final Fit fit;
  final String? assetPath;
  final String fallbackUrl;

  @override
  State<RiveHero> createState() => _RiveHeroState();
}

class _RiveHeroState extends State<RiveHero> {
  late final FileLoader _fileLoader;

  @override
  void initState() {
    super.initState();
    if (widget.assetPath != null && widget.assetPath!.isNotEmpty) {
      _fileLoader = FileLoader.fromAsset(
        widget.assetPath!,
        riveFactory: Factory.flutter,
      );
    } else {
      _fileLoader = FileLoader.fromUrl(
        widget.fallbackUrl,
        riveFactory: Factory.flutter,
      );
    }
  }

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: RiveWidgetBuilder(
        fileLoader: _fileLoader,
        builder: (context, state) => switch (state) {
          RiveLoading() => _buildPlaceholder(),
          RiveFailed() => _buildPlaceholder(isError: true),
          RiveLoaded() => RiveWidget(
              controller: state.controller,
              fit: widget.fit,
            ),
        },
        onFailed: (_, __) {
          // Optional: log or show snackbar
        },
      ),
    );
  }

  Widget _buildPlaceholder({bool isError = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg2.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.line.withValues(alpha: 0.6),
        ),
      ),
      child: Center(
        child: isError
            ? Icon(
                Icons.image_not_supported_outlined,
                size: 48,
                color: AppColors.textTertiary.withValues(alpha: 0.8),
              )
            : SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accentCyan.withValues(alpha: 0.8),
                ),
              ),
      ),
    );
  }
}
