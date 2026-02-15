import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      surface: Colors.white,
      surfaceContainer: Colors.white,
      primary: Colors.amber,
      tertiary: Colors.black,
      secondary: Colors.grey[400],
      seedColor: Colors.amber,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      surface: Colors.grey[900],
      surfaceContainer: Colors.grey[800],
      primary: Colors.amber,
      tertiary: Colors.white,
      secondary: Colors.white,
      seedColor: Colors.amber,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}


// Icon Map
// surface = background
// surfaceContainer = simple containers
// primary = main
// seconday = icons and such..
// tertiary = text