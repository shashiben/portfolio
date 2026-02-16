import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

const _themeKey = 'theme_mode';

class ThemeService extends ChangeNotifier {
  ThemeService() {
    _init();
  }

  AppThemeMode _themeMode = AppThemeMode.system;

  AppThemeMode get themeMode => _themeMode;

  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeKey);
    if (stored != null) {
      for (final mode in AppThemeMode.values) {
        if (mode.name == stored) {
          _themeMode = mode;
          notifyListeners();
          break;
        }
      }
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _themeMode.name);
  }

  void setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    _save();
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    _save();
    notifyListeners();
  }
}
