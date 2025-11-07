import 'package:esae_monie/services/persistence_services.dart';
import 'package:flutter/material.dart';

class ThemeService {
  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
    ThemeMode.system,
  );
  static final PersistenceService _persistenceService = PersistenceService();

  static Future<void> initializeTheme() async {
    final savedTheme = await _persistenceService.getThemeMode();

    switch (savedTheme) {
      case 'light':
        themeModeNotifier.value = ThemeMode.light;
        break;
      case 'dark':
        themeModeNotifier.value = ThemeMode.dark;
        break;
      case 'system':
      default:
        themeModeNotifier.value = ThemeMode.system;
        break;
    }
  }

  // Toggle between light and dark (skips system mode)
  static Future<void> toggleTheme() async {
    final currentMode = themeModeNotifier.value;
    final newMode = currentMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    await setThemeMode(newMode);
  }

  // Set specific theme mode
  static Future<void> setThemeMode(ThemeMode mode) async {
    String themeString;
    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = 'system';
        break;
    }

    await _persistenceService.saveThemeMode(themeString);
    themeModeNotifier.value = mode;
  }

  static ThemeMode get currentTheme => themeModeNotifier.value;
  static bool isDarkMode(BuildContext context) {
    switch (themeModeNotifier.value) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }
}
