import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/widgets/Drawer%20Widgets/expansion_tile_modified.dart';

class DrawerHoverEffect extends StatefulWidget {
  final Widget child;
  final List<Widget> children;
  final void Function(bool) onChanged;
  final LabeledGlobalKey buttonKey;
  final double mobileMaxWidth;
  const DrawerHoverEffect(
      {Key? key,
      required this.child,
      required this.mobileMaxWidth,
      required this.onChanged,
      required this.children,
      required this.buttonKey})
      : super(key: key);

  @override
  _DrawerHoverEffectState createState() => _DrawerHoverEffectState();
}

class _DrawerHoverEffectState extends State<DrawerHoverEffect> {
  StreamController<bool> _streamController = StreamController<bool>.broadcast();
  LabeledGlobalKey _overlayKey = LabeledGlobalKey("overlay");
  late OverlayState overlayState;
  late OverlayEntry _overlayEntry;
  late Offset buttonPosition;
  Size buttonSize = Size(0, 0);
  bool isOpened = false;
  late StreamSubscription _listenHoverChanges;

  void openMenu() {
    findButton();
    Overlay.of(context)?.insert(_overlayEntry);
  }

  void closeMenu() {
    _overlayEntry.remove();
  }

  findButton() {
    RenderBox renderBox =
        widget.buttonKey.currentContext!.findRenderObject()! as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
            key: _overlayKey,
            top: buttonPosition.dy + buttonSize.height + 10,
            left: buttonPosition.dx,
            width: buttonSize.width,
            child: MouseRegion(
              onExit: (value) {
                if (isOpened) _streamController.add(false);
              },
              child: Material(
                color: Color(0xFF050028).withOpacity(0.8),
                child: Column(
                  children: widget.children,
                ),
              ),
            ));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _listenHoverChanges.cancel();
    if (isOpened) {
      closeMenu();
    }
  }

  @override
  void initState() {
    super.initState();
    _overlayEntry = _overlayEntryBuilder();
    _listenHoverChanges = _streamController.stream.listen((event) {
      widget.onChanged(event);
      setState(() {
        isOpened = event;
      });
      print("Event from state is:$event");
      if (event) {
        openMenu();
      } else {
        closeMenu();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUiHelper screenUiHelper = ScreenUiHelper.fromContext(context);
    return widget.children.isEmpty
        ? widget.child
        : screenUiHelper.width > widget.mobileMaxWidth
            ? MouseRegion(
                onEnter: (value) {
                  if (!isOpened) {
                    _streamController.add(true);
                  }
                },
                onExit: (value) {
                  if (value.localPosition.dx <= 0 ||
                      value.localPosition.dx > buttonSize.width ||
                      value.localPosition.dy <= 0) {
                    if (isOpened) _streamController.add(false);
                  } else {
                    if (_overlayKey.currentContext == null) {
                      if (isOpened) _streamController.add(false);
                    }
                  }
                },
                child: widget.child,
              )
            : XpansionTile(
                childrenPadding: const EdgeInsets.only(left: 50),
                borderColor: Colors.transparent,
                tilePadding: EdgeInsets.zero,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                trailing: SizedBox(),
                title: widget.child,
                children: widget.children,
              );
  }
}
