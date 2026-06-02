import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Theme Provider — управление темой приложения (Light/Dark)
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeProvider() {
    _loadTheme();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isInitialized => _isInitialized;

  // Get current theme
  ThemeData get currentTheme {
    switch (_themeMode) {
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.system:
        default:
        return AppTheme.lightTheme;
    }
  }

  // Load theme from preferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      
      _themeMode = ThemeMode.values[themeIndex];
      _isInitialized = true;
      
      AppLogger.info('Theme loaded: ${_themeMode.name}');
      notifyListeners();
    } catch (e, st) {
      AppLogger.error('Failed to load theme', e, st);
      _themeMode = ThemeMode.light;
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    try {
      _themeMode = mode;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, mode.index);
      
      AppLogger.info('Theme changed to: ${mode.name}');
      notifyListeners();
    } catch (e, st) {
      AppLogger.error('Failed to save theme', e, st);
    }
  }

  // Toggle between light and dark
  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  // Set light mode
  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  // Set dark mode
  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  // Set system mode
  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }
}
