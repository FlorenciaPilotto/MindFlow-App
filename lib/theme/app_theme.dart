import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      colorScheme: const ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        labelStyle: TextStyle(color: Colors.blue),
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.grey,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey,
      colorScheme: const ColorScheme.dark(
        primary: Colors.blueGrey,
        secondary: Colors.lightBlue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue),
        ),
        labelStyle: TextStyle(color: Colors.lightBlue),
      ),
      cardTheme: const CardTheme(
        color: Colors.black,
        elevation: 4,
        shadowColor: Colors.grey,
      ),
    );
  }
}
