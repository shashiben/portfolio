import 'package:flutter/material.dart';

import '../../app/tokens/tokens.dart';

class PageShell extends StatelessWidget {
  const PageShell({
    super.key,
    required this.child,
    this.maxWidth = 1000,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.lg,
            vertical: SpacingTokens.xl,
          ),
          child: child,
        ),
      ),
    );
  }
}
