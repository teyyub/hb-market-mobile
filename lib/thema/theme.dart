// theme.dart
import 'package:flutter/material.dart';

final InputDecorationTheme myInputDecorationTheme = InputDecorationTheme(
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
    borderRadius: BorderRadius.circular(10),
  ),
  labelStyle: const TextStyle(fontSize: 14),
  hintStyle: const TextStyle(fontSize: 14),
);

final ThemeData myTheme = ThemeData(
  inputDecorationTheme: myInputDecorationTheme,
);

/// Light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  inputDecorationTheme: myInputDecorationTheme,
);

/// Dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.tealAccent,
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  canvasColor: const Color(0xFF1A1A1A),
  inputDecorationTheme: myInputDecorationTheme.copyWith(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.tealAccent, width: 1.5),
      borderRadius: BorderRadius.circular(10),
    ),
    hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
    labelStyle: const TextStyle(color: Colors.grey),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.teal[700],
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.tealAccent,
    foregroundColor: Colors.black,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.tealAccent,
    secondary: Colors.orangeAccent,
  ),
);
