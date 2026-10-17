part of 'skill_galaxy.dart';

extension _SkillGalaxyStage on _SkillGalaxyState {
  Widget _layout(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 800;
    final size = wide ? 480.0 : math.min(400.0, width - 48);

    final stage = VisibilityDetector(
      key: const ValueKey('skill-galaxy'),
      onVisibilityChanged: (info) {
        final v = info.visibleFraction > 0.05;
        if (v != _visible && mounted) {
          _visible = v;
          _sync();
        }
      },
      child: _stage(size),
    );

    final side = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _selected,
          builder: (context, i, _) => _ScanPanel(skill: _skills[i], group: _groupOfSkill[i], index: i, total: _n),
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder<String?>(
          valueListenable: _group,
          builder: (context, active, _) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final g in _groups)
                _GroupChip(
                  label: g,
                  count: _groupOfSkill.where((s) => s == g).length,
                  active: active == g,
                  onHover: (inside) => _onGroupHover(g, inside),
                  onTap: () => _onGroupTap(g),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Drag to spin  ·  tap a skill to scan',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.appColors.textTertiary),
        ),
      ],
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 340, child: side),
          const SizedBox(width: 32),
          Expanded(child: Center(child: stage)),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: stage),
        const SizedBox(height: 24),
        side,
      ],
    );
  }

  Widget _stage(double size) {
    return MouseRegion(
      onEnter: (_) => _hovering = true,
      onExit: (_) => _hovering = false,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: SizedBox.square(
          dimension: size,
          child: AnimatedBuilder(
            animation: Listenable.merge([_frame, _selected, _group]),
            builder: (context, _) => _scene(context, size),
          ),
        ),
      ),
    );
  }

  Widget _scene(BuildContext context, double size) {
    final c = context.appColors;
    final center = size / 2;
    final radius = size * 0.36;
    final sel = _selected.value;
    final group = _group.value;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _GalaxyPainter(
                yaw: _yaw,
                pitch: _pitch,
                px: _px,
                py: _py,
                pz: _pz,
                groupOfSkill: _groupOfSkill,
                selected: sel,
                group: group,
                radius: radius,
                accent: c.accent,
                line: c.line,
              ),
            ),
          ),
        ),
        for (final i in _order) _node(i, center, radius, sel, group),
      ],
    );
  }

  Widget _node(int i, double center, double radius, int sel, String? group) {
    final z = _pz[i];
    final persp = 2.6 / (2.6 - z);
    final depth = (z + 1) / 2;
    final scale = 0.55 + 0.6 * depth;
    final inGroup = group == null || _groupOfSkill[i] == group;
    final opacity = inGroup ? (0.25 + 0.75 * depth).clamp(0.0, 1.0) : 0.1;
    final dx = center + _px[i] * radius * persp;
    final dy = center + _py[i] * radius * persp;

    return Positioned(
      key: ValueKey(i),
      left: dx - _nodeBox / 2,
      top: dy - _nodeBox / 2,
      width: _nodeBox,
      height: _nodeBox,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: _GalaxyNode(
            icon: _icons[i],
            label: _skills[i].title,
            selected: i == sel,
            highlighted: group != null && inGroup,
            showLabel: depth > 0.72 || i == sel,
            onTap: () => _select(i, user: true),
          ),
        ),
      ),
    );
  }
}
