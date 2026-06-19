import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      surface: Colors.white,
      surfaceContainer: Colors.white,
      primary: Colors.amber,
      primaryContainer: Colors.grey[100],
      inversePrimary: Colors.white,
      tertiary: Colors.black,
      secondary: Colors.grey[400],
      seedColor: Colors.amber,
      secondaryContainer: Colors.amber[300],

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
      primaryContainer: Colors.grey[800],
      inversePrimary: Colors.grey[400],
      tertiary: Colors.white,
      secondary: Colors.white,
      seedColor: Colors.amber,
      secondaryContainer: Colors.grey[800],

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