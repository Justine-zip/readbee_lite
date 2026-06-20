import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);

    if (themeIndex != null) {
      state = ThemeMode.values[themeIndex];
    }
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, state.index);
  }

  Future<void> toggleTheme() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await _saveTheme();
  }

  Future<void> setLight() async {
    state = ThemeMode.light;
    await _saveTheme();
  }

  Future<void> setDark() async {
    state = ThemeMode.dark;
    await _saveTheme();
  }

  Future<void> setSystem() async {
    state = ThemeMode.system;
    await _saveTheme();
  }
}
