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
    final radius = size / 2 + 64;
    final extent = radius + _menuSlot / 2;
    final spread = n < 6 ? math.pi * 0.62 : 2 * math.pi * (n - 1) / n;
    final labelStyle = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: ColorTokens.omniTextPrimary, letterSpacing: 1);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => _setOpen(false)),
        ),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.center,
          followerAnchor: Alignment.center,
          child: SizedBox.square(
            dimension: extent * 2,
            child: IgnorePointer(
              ignoring: !_open,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < n; i++)
                    _radialNode(
                      items[i],
                      i,
                      extent,
                      _fitRadialTarget(
                        Offset.fromDirection(
                          _facing - spread / 2 + (n == 1 ? spread / 2 : i * spread / (n - 1)),
                          radius,
                        ),
                      ),
                      labelStyle,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Offset _fitRadialTarget(Offset target) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return target;
    final screen = MediaQuery.sizeOf(context);
    final pad = MediaQuery.viewPaddingOf(context);
    const edge = 40.0;
    final minX = pad.left + edge;
    final minY = pad.top + edge;
    final maxX = math.max(minX, screen.width - pad.right - edge);
    final maxY = math.max(minY, screen.height - pad.bottom - edge);
    final center = box.localToGlobal(box.size.center(Offset.zero));
    final dest = center + target;
    return Offset(dest.dx.clamp(minX, maxX), dest.dy.clamp(minY, maxY)) - center;
  }

  Widget _radialNode(OmniDialItem item, int i, double extent, Offset target, TextStyle? labelStyle) {
    final selected = i == _index;
    final image = item.image;
    final fg = selected ? Colors.black : ColorTokens.omniGreen;
    final art = image == null
        ? Icon(item.icon ?? Icons.circle, size: 20, color: fg)
        : _isNetworkUrl(image)
        ? SvgPicture.network(image, width: 22, height: 22)
        : Image.asset(image, width: 22, height: 22);

    return Positioned(
      left: extent - _menuSlot / 2,
      top: extent - _menuNode / 2,
      width: _menuSlot,
      child: AnimatedBuilder(
        animation: _menuT,
        builder: (context, child) => Transform.translate(
          offset: _fitRadialTarget(target * _menuT.value),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    const SizedBox(height: 4),
                    ExcludeSemantics(
                      child: Text(item.label, style: labelStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
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
