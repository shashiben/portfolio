import 'package:flutter/material.dart';

class DeferredLoader extends StatefulWidget {
  const DeferredLoader({
    super.key,
    required this.loadLibrary,
    required this.builder,
    this.loading,
  });

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
        final loaded = snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError;
        final content = loaded
            ? widget.builder(context)
            : (widget.loading ??
                const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ));
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: KeyedSubtree(
            key: ValueKey(loaded),
            child: content,
          ),
        );
      },
    );
  }
}
