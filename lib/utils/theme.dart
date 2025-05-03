import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: const Color(0xFF1E88E5),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1E88E5),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF1E88E5),
      unselectedItemColor: Colors.grey,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF1E88E5),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1E88E5),
      surface: Color(0xFF121212),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1F1F1F),
      selectedItemColor: Color(0xFF1E88E5),
      unselectedItemColor: Colors.grey,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF1F1F1F),
    ),
  );
}