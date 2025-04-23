// File: lib/utils/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColor = Color(0xFF1E88E5);
  static final Color accentColor = Color(0xFFFFA000);
  static final Color errorColor = Color(0xFFD32F2F);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
  );
}
