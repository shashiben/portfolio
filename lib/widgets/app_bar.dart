import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';
import '../app/constants/data/my_info.data.dart';
import '../app/constants/route_constants.dart';
import '../app/theme/app_theme_colors.dart';
import '../core/services/theme_service.dart';
import 'components/hover_fx.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  static const List<_NavItem> _navItems = [
    _NavItem(path: RouteConstants.home, label: 'Home'),
    _NavItem(path: RouteConstants.about, label: 'About'),
    _NavItem(path: RouteConstants.experience, label: 'Experience'),
    _NavItem(path: RouteConstants.projects, label: 'Projects'),
    _NavItem(path: RouteConstants.contact, label: 'Contact'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final currentPath = GoRouterState.of(context).uri.path;
    final isWide = MediaQuery.sizeOf(context).width >= 800;
    final themeService = locator.get<ThemeService>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 32 : 24,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: c.bg1,
        border: Border(
          bottom: BorderSide(color: c.line),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          HoverFx(
            onTap: () => router.go(RouteConstants.home),
            child: Text(
              MYInfo.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
            ),
          ),
          const SizedBox(width: 32),
          if (isWide) ...[
            ..._navItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _NavLink(
                  path: item.path,
                  label: item.label,
                  isSelected: _isSelected(currentPath, item.path),
                ),
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            icon: Icon(
              themeService.themeMode == AppThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: c.textSecondary,
            ),
            onPressed: () => themeService.toggleTheme(),
          ),
          if (!isWide)
            IconButton(
              icon: Icon(Icons.menu_rounded, color: c.textPrimary),
              onPressed: () => _showMobileNav(context, currentPath),
            )
          else
            FilledButton(
              onPressed: () => router.go(RouteConstants.contact),
              child: const Text('Get in touch'),
            ),
        ],
      ),
    );
  }

  static bool _isSelected(String current, String path) {
    if (path == RouteConstants.home) return current == RouteConstants.home;
    return current.startsWith(path);
  }

  static void _showMobileNav(BuildContext context, String currentPath) {
    final c = context.appColors;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.bg1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._navItems.map(
              (item) => ListTile(
                title: Text(
                  item.label,
                  style: TextStyle(
                    color: _isSelected(currentPath, item.path) ? c.accent : c.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  router.go(item.path);
                },
              ),
            ),
            ListTile(
              title: Text(
                'Get in touch',
                style: TextStyle(
                  color: c.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(ctx);
                router.go(RouteConstants.contact);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.path, required this.label});
  final String path;
  final String label;
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.path,
    required this.label,
    required this.isSelected,
  });

  final String path;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return HoverFx(
      onTap: () => router.go(path),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? c.textPrimary : c.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
