import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/constants/data/my_info.data.dart';
import '../../app/constants/route_constants.dart';
import '../../app/theme/app_motion.dart';
import '../../app/theme/app_theme_colors.dart';
import '../../core/services/url_launcher_service.dart';
import '../fx/fx.dart';

void _transformTo(String path) {
  final cue = transformCue(path);
  transformController.play(style: cue.style, label: cue.label, atPeak: () => router.go(path));
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  static const List<_NavItem> _navItems = [
    _NavItem(path: RouteConstants.home, label: 'Home'),
    _NavItem(path: RouteConstants.journey, label: 'Journey'),
    _NavItem(path: RouteConstants.work, label: 'Work'),
    _NavItem(path: RouteConstants.contact, label: 'Contact'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 800;
    final currentPath = GoRouterState.of(context).uri.path;
    final selected = _navItems.indexWhere((item) => currentPath.startsWith(item.path));

    final top = MediaQuery.viewPaddingOf(context).top;
    return Container(
      padding: EdgeInsets.fromLTRB(isWide ? 32 : 16, 12 + top, isWide ? 32 : 16, 12),
      decoration: BoxDecoration(
        color: c.bg0.withValues(alpha: 0.72),
        border: Border(bottom: BorderSide(color: c.accent.withValues(alpha: 0.18))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _transformTo(RouteConstants.home),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ScrambleText(
                MYInfo.name,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const Spacer(),
          if (isWide) _NavLinks(items: _navItems, selected: selected),
          const Spacer(),
          MagneticButton(
            onTap: () => locator.get<UrlLauncherService>().open(MYInfo.resumeLink),
            child: isWide ? const _ResumeChip() : Icon(Icons.description_outlined, color: c.accent),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.path, required this.label});
  final String path;
  final String label;
}

class _NavLinks extends StatelessWidget {
  const _NavLinks({required this.items, required this.selected});

  static const double _slot = 96;
  static const double _bar = 28;

  final List<_NavItem> items;
  final int selected;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final duration = AppMotion.reduceMotion(context) ? Duration.zero : AppMotion.medium;
    return SizedBox(
      width: _slot * items.length,
      height: 40,
      child: Stack(
        children: [
          Row(
            children: [
              for (var i = 0; i < items.length; i++)
                SizedBox(
                  width: _slot,
                  child: _NavLink(item: items[i], isSelected: i == selected),
                ),
            ],
          ),
          AnimatedPositioned(
            duration: duration,
            curve: AppMotion.easeOut,
            left: (selected < 0 ? 0 : selected) * _slot + (_slot - _bar) / 2,
            bottom: 2,
            child: AnimatedOpacity(
              duration: duration,
              opacity: selected < 0 ? 0 : 1,
              child: Container(
                width: _bar,
                height: 2,
                decoration: BoxDecoration(
                  color: c.accent,
                  boxShadow: [BoxShadow(color: c.accent.withValues(alpha: 0.6), blurRadius: 6)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.item, required this.isSelected});

  final _NavItem item;
  final bool isSelected;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final bright = widget.isSelected || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.isSelected ? null : () => _transformTo(widget.item.path),
        child: Center(
          child: Text(
            widget.item.label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: widget.isSelected ? c.accent : (bright ? c.textPrimary : c.textSecondary),
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResumeChip extends StatelessWidget {
  const _ResumeChip();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: c.accent.withValues(alpha: 0.7))),
      child: Text(
        'RESUME',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c.accent, letterSpacing: 1.6),
      ),
    );
  }
}
