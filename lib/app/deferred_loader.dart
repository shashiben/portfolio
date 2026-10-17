import 'package:flutter/material.dart';

import 'tokens/color_tokens.dart';

class DeferredLoader extends StatefulWidget {
  const DeferredLoader({super.key, required this.loadLibrary, required this.builder, this.loading});

  final Future<void> Function() loadLibrary;
  final WidgetBuilder builder;
  final Widget? loading;

  @override
  State<DeferredLoader> createState() => _DeferredLoaderState();
}

class _DeferredLoaderState extends State<DeferredLoader> {
  late final Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = widget.loadLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        final loaded = snapshot.connectionState == ConnectionState.done && !snapshot.hasError;
        if (!loaded) {
          return widget.loading ?? const ColoredBox(color: ColorTokens.omniVoid, child: SizedBox.expand());
        }
        return widget.builder(context);
      },
    );
  }
}
