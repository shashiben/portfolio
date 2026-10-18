part of 'omnitrix.dart';

Path _horizontalLead(Size s) => Path()
  ..moveTo(0, s.height / 2)
  ..lineTo(s.width, s.height / 2)
  ..moveTo(s.width, s.height * 0.2)
  ..lineTo(s.width, s.height * 0.8);

Path _verticalLead(Size s) => Path()
  ..moveTo(s.width / 2, 0)
  ..lineTo(s.width / 2, s.height)
  ..moveTo(s.width * 0.2, s.height)
  ..lineTo(s.width * 0.8, s.height);

extension _OmnitrixBuild on _OmnitrixWidgetState {
  Widget _buildDial(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();
    if (_isDock) {
      return CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
          controller: _portal,
          overlayChildBuilder: (_) => _radialMenu(items, widget.size ?? _dockSize),
          child: _dial(items, widget.size ?? _dockSize),
        ),
      );
    }
    return LayoutBuilder(builder: (context, c) => _hero(items, c));
  }

  Widget _hero(List<OmniDialItem> items, BoxConstraints c) {
    final fixed = widget.size?.clamp(_minSize, _maxSize) ?? 0;
    if (widget.size != null) return _dial(items, fixed.toDouble());
    final tight = c.maxWidth < math.max(_tightWidth, fixed + _calloutGap + _panelWidth);
    final size = tight
        ? _heroSize(c.maxWidth, c.hasBoundedHeight ? c.maxHeight - _calloutHeight : double.infinity)
        : _heroSize(c.maxWidth - _calloutGap - _panelWidth, c.maxHeight);
    final dial = _dial(items, size);
    final panel = _callout(items[_index], items.length);
    if (tight) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          dial,
          SizedBox(
            width: 24,
            height: 32,
            child: LineDraw(key: ValueKey(_step), pathBuilder: _verticalLead, color: ColorTokens.omniGreen),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _panelWidth * 1.5),
            child: panel,
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dial,
        SizedBox(
          width: _calloutGap,
          height: 24,
          child: LineDraw(key: ValueKey(_step), pathBuilder: _horizontalLead, color: ColorTokens.omniGreen),
        ),
        SizedBox(width: _panelWidth, child: panel),
      ],
    );
  }

  Widget _callout(OmniDialItem item, int count) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: ColorTokens.omniPanel,
        border: Border.all(color: ColorTokens.omniGreen.withValues(alpha: 0.6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DNA ${(_index + 1).toString().padLeft(2, '0')}/${count.toString().padLeft(2, '0')}',
            style: text.labelSmall?.copyWith(color: ColorTokens.omniTextTertiary, letterSpacing: 2),
          ),
          const SizedBox(height: 4),
          ScrambleText(
            item.label,
            key: ValueKey(_step),
            style: text.titleMedium?.copyWith(
              color: ColorTokens.omniTextPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          if (item.subtitle != null) ...[
            const SizedBox(height: 2),
            Text(item.subtitle!, style: text.bodySmall?.copyWith(color: ColorTokens.omniTextSecondary)),
          ],
        ],
      ),
    );
  }

  Widget _dial(List<OmniDialItem> items, double size) {
    final scale = size / _baseSize;
    final node = SpacingTokens.omnitrixSmallRadius * scale;
    final inner = size - 2 * node;
    _dialSize = size;
    _innerSize = inner;
    final nodeWidget = _node(node, scale);
    final edge = (size - node) / 2;

    Widget dial = SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedRotation(
            turns: _step / items.length,
            duration: _reduceMotion ? Duration.zero : AppMotion.medium,
            curve: AppMotion.spring,
            child: RepaintBoundary(
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.square(size),
                    painter: _OuterRingPainter(innerRadius: inner / 2, glow: _shutter, glowSpread: 12 * scale),
                  ),
                  Positioned(top: 0, left: edge, child: nodeWidget),
                  Positioned(left: 0, top: edge, child: nodeWidget),
                  Positioned(right: 0, top: edge, child: nodeWidget),
                  Positioned(bottom: 0, left: edge, child: nodeWidget),
                ],
              ),
            ),
          ),
          _core(items[_index], inner, scale),
          IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(size: Size.square(size), painter: _ShockwavePainter(_shock, scale)),
            ),
          ),
          Positioned(left: 0, top: edge, width: node, height: node, child: _sideTap(() => _move(-1))),
          Positioned(right: 0, top: edge, width: node, height: node, child: _sideTap(() => _move(1))),
        ],
      ),
    );

    if (!_isDock) {
      dial = GestureDetector(onPanStart: _onPanStart, onPanUpdate: _onPanUpdate, onPanEnd: _onPanEnd, child: dial);
    }

    return FxVisibility(
      onShow: () {
        _visible = true;
        _syncIdle();
      },
      onHide: () {
        _visible = false;
        _syncIdle();
      },
      child: Focus(
        focusNode: _focus,
        onKeyEvent: _onKey,
        child: Semantics(
          button: true,
          label: _isDock ? 'Omnitrix menu: ${items[_index].label}' : 'Omnitrix: ${items[_index].label}',
          child: ScaleTransition(scale: _bounceScale, child: dial),
        ),
      ),
    );
  }

  Widget _sideTap(VoidCallback onTap) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap),
  );

  Widget _node(double node, double scale) => Container(
    width: node,
    height: node,
    padding: EdgeInsets.all(SpacingTokens.omnitrixRingPadding * scale),
    decoration: BoxDecoration(border: Border.all(), shape: BoxShape.circle, color: const Color(0xFF363636)),
    child: Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        ),
        FadeTransition(
          opacity: _glow,
          child: const DecoratedBox(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.greenAccent),
          ),
        ),
      ],
    ),
  );

  Widget _core(OmniDialItem item, double inner, double scale) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _onCoreTap,
        child: SizedBox.square(
          dimension: inner,
          child: Container(
            padding: EdgeInsets.all(SpacingTokens.omnitrixInnerPadding * scale),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            child: Container(
              padding: EdgeInsets.all(SpacingTokens.omnitrixRingPadding * scale),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Container(
                padding: EdgeInsets.all(SpacingTokens.omnitrixRingPadding * scale),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SpacingTokens.omnitrixBorderRadius * scale),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                        color: const Color(0xFF363636),
                        child: ClipPath(
                          clipper: DiamondClipper(),
                          child: ColoredBox(
                            color: Colors.black,
                            child: Padding(
                              padding: EdgeInsets.all(SpacingTokens.omnitrixContentPadding * scale),
                              child: ClipPath(
                                clipper: DiamondClipper(),
                                child: FadeTransition(
                                  opacity: _fadeOut,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      const ColoredBox(color: Colors.green),
                                      FadeTransition(
                                        opacity: _glow,
                                        child: ColoredBox(color: Colors.greenAccent.withValues(alpha: 0.6)),
                                      ),
                                      Center(
                                        child: RepaintBoundary(
                                          child: AnimatedSwitcher(
                                            duration: _reduceMotion ? Duration.zero : AppMotion.micro,
                                            child: KeyedSubtree(key: ValueKey(_step), child: _art(item, inner, scale)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _shutterBlade(Alignment.centerLeft, TriangleType.left, Colors.black),
                          _shutterBlade(Alignment.centerRight, TriangleType.right, Colors.black),
                        ],
                      ),
                      Column(
                        children: [
                          _shutterBlade(Alignment.topCenter, TriangleType.top, Colors.white),
                          _shutterBlade(Alignment.bottomCenter, TriangleType.bottom, Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shutterBlade(Alignment alignment, TriangleType type, Color color) => Expanded(
    child: IgnorePointer(
      child: ScaleTransition(
        alignment: alignment,
        scale: _shutterScale,
        child: ClipPath(
          clipper: TriangleClipperr(type: type),
          child: ColoredBox(color: color),
        ),
      ),
    ),
  );

  Widget _art(OmniDialItem item, double inner, double scale) {
    final image = item.image;
    final fallback = Icon(item.icon ?? Icons.code, size: inner / 3, color: Colors.black87);
    if (image == null) return fallback;
    if (_isNetworkUrl(image)) {
      return SvgPicture.network(
        image,
        fit: BoxFit.contain,
        height: 50 * scale,
        width: 50 * scale,
        placeholderBuilder: (_) => Icon(item.icon ?? Icons.code, size: 50 * scale, color: Colors.white70),
      );
    }
    return Image.asset(image, fit: BoxFit.contain, height: inner / 2, width: inner / 2);
  }

  Widget _radialMenu(List<OmniDialItem> items, double size) {
    final n = items.length;
    final offsets = _menuOffsets(n, size);
    final reach = offsets.fold<double>(size, (m, o) => math.max(m, o.distance)) + 96;
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(color: ColorTokens.omniTextPrimary);

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => _setOpen(false)),
          ),
          CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.center,
            followerAnchor: Alignment.center,
            child: SizedBox.square(
              dimension: reach * 2,
              child: IgnorePointer(
                ignoring: !_open,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [for (var i = 0; i < n; i++) _radialNode(items[i], i, reach, offsets[i], labelStyle)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Centers of the open fan, in the free space around the dial. Circles stay
  /// a label-width apart so hits and text don't land on the next item.
  List<Offset> _menuOffsets(int n, double dialSize) {
    if (n == 0) return const [];
    final box = context.findRenderObject() as RenderBox?;
    final screen = MediaQuery.sizeOf(context);
    final facing = box != null && box.hasSize ? _facing : -math.pi * 0.75;
    if (n == 1) return [Offset.fromDirection(facing, dialSize / 2 + 96)];

    final pad = MediaQuery.viewPaddingOf(context);
    final center = box != null && box.hasSize
        ? box.localToGlobal(box.size.center(Offset.zero))
        : screen.center(Offset.zero);
    const edge = 72.0;
    final spaceL = math.max(0.0, center.dx - pad.left - edge);
    final spaceR = math.max(0.0, screen.width - pad.right - edge - center.dx);
    final spaceT = math.max(0.0, center.dy - pad.top - edge);
    final spaceB = math.max(0.0, screen.height - pad.bottom - edge - center.dy);

    double roomAlong(double angle) {
      final u = Offset(math.cos(angle), math.sin(angle));
      final dx = u.dx >= 0 ? spaceR : spaceL;
      final dy = u.dy >= 0 ? spaceB : spaceT;
      final ax = u.dx.abs() < 1e-4 ? double.infinity : dx / u.dx.abs();
      final ay = u.dy.abs() < 1e-4 ? double.infinity : dy / u.dy.abs();
      return math.min(ax, ay);
    }

    const minChord = _menuNode + 36;
    final minRadius = dialSize / 2 + _menuNode / 2 + 28;
    final prefer = math.min(dialSize / 2 + 128, math.max(minRadius, roomAlong(facing) - 8));

    bool fits(double half, double radius) {
      final step = 2 * half / (n - 1);
      for (var i = 0; i < n; i++) {
        if (roomAlong(facing - half + i * step) < radius) return false;
      }
      return 2 * radius * math.sin(step / 2) >= minChord - 0.5;
    }

    double halfFor(double radius) {
      final s = (minChord / (2 * radius)).clamp(0.0, 0.95);
      return (2 * math.asin(s)) * (n - 1) / 2;
    }

    var radius = prefer;
    var half = math.min(1.15, math.max(halfFor(radius), 0.72));
    if (!fits(half, radius)) {
      var found = false;
      for (var h = half; h >= 0.5; h -= 0.04) {
        if (!fits(h, radius)) continue;
        half = h;
        found = true;
        break;
      }
      if (!found) {
        for (var r = prefer; r >= minRadius; r -= 6) {
          final h = math.min(1.05, math.max(halfFor(r), 0.55));
          if (!fits(h, r)) continue;
          radius = r;
          half = h;
          found = true;
          break;
        }
      }
      if (!found) {
        radius = minRadius;
        half = math.min(1.05, math.max(halfFor(minRadius), 0.55));
      }
    }

    final step = 2 * half / (n - 1);
    return [for (var i = 0; i < n; i++) Offset.fromDirection(facing - half + i * step, radius)];
  }

  Widget _radialNode(OmniDialItem item, int i, double reach, Offset target, TextStyle? labelStyle) {
    final selected = i == _index;
    final image = item.image;
    final fg = selected ? Colors.black : ColorTokens.omniGreen;
    final art = image == null
        ? Icon(item.icon ?? Icons.circle, size: 20, color: fg)
        : _isNetworkUrl(image)
        ? SvgPicture.network(image, width: 22, height: 22)
        : Image.asset(image, width: 22, height: 22);
    final dir = target.distance < 1 ? Offset.fromDirection(_facing) : target / target.distance;
    final out = dir * (_menuNode / 2 + 8);

    return Positioned(
      left: reach - _menuNode / 2,
      top: reach - _menuNode / 2,
      width: _menuNode,
      height: _menuNode,
      child: AnimatedBuilder(
        animation: _menuT,
        builder: (context, child) => Transform.translate(
          offset: target * _menuT.value,
          child: Transform.scale(scale: 0.4 + 0.6 * _menuT.value, child: child),
        ),
        child: FadeTransition(
          opacity: _menu,
          child: Semantics(
            button: true,
            selected: selected,
            label: item.label,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _selectFromMenu(i),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: _menuNode,
                      height: _menuNode,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? ColorTokens.omniGreen : ColorTokens.omniPanel,
                        border: Border.all(color: ColorTokens.omniGreen, width: 1.5),
                      ),
                      child: art,
                    ),
                    Positioned(
                      left: _menuNode / 2 + out.dx - 40,
                      top: _menuNode / 2 + out.dy - 8,
                      width: 80,
                      height: 16,
                      child: IgnorePointer(
                        child: ExcludeSemantics(
                          child: Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: labelStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
