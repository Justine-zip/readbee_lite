import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      surface: Colors.white,
      surfaceContainer: Colors.white,
      surfaceVariant: Colors.black,
      primary: Colors.amber,
      inversePrimary: Colors.white,
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
      surfaceVariant: Colors.grey[800],
      primary: Colors.amber,
      inversePrimary: Colors.grey[400],
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