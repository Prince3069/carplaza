import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _primaryLight = Color(0xFF1E88E5); // Primary blue
  static const Color _secondaryLight = Color(0xFF42A5F5); // Lighter blue
  static const Color _accentLight = Color(0xFF1565C0); // Darker blue
  static const Color _backgroundLight = Color(0xFFFFFFFF); // White background
  static const Color _surfaceLight = Color(0xFFFAFAFA); // Slightly off-white
  static const Color _errorLight = Color(0xFFD32F2F); // Red for errors
  static const Color _textLight = Color(0xFF212121); // Dark text
  static const Color _hintLight = Color(0xFF757575); // Gray hint text

  // Dark Theme Colors
  static const Color _primaryDark = Color(0xFF1565C0); // Darker blue
  static const Color _secondaryDark = Color(0xFF1E88E5); // Primary blue
  static const Color _accentDark = Color(0xFF42A5F5); // Lighter blue
  static const Color _backgroundDark = Color(0xFF121212); // Dark background
  static const Color _surfaceDark = Color(0xFF1E1E1E); // Dark surface
  static const Color _errorDark = Color(0xFFEF5350); // Light red for errors
  static const Color _textDark = Color(0xFFFFFFFF); // White text
  static const Color _hintDark = Color(0xFFBDBDBD); // Light gray hint

  // Text Styles
  static const TextStyle _headline1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle _headline2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle _headline3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle _bodyText1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle _bodyText2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle _buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  static const TextStyle _caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryLight,
    colorScheme: const ColorScheme.light(
      primary: _primaryLight,
      secondary: _secondaryLight,
      surface: _surfaceLight,
      background: _backgroundLight,
      error: _errorLight,
    ),
    scaffoldBackgroundColor: _backgroundLight,
    appBarTheme: const AppBarTheme(
      color: _primaryLight,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: _surfaceLight,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: _primaryLight,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: _buttonText.copyWith(color: Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryLight,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryLight,
        side: const BorderSide(color: _primaryLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _errorLight),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    textTheme: TextTheme(
      displayLarge: _headline1.copyWith(color: _textLight),
      displayMedium: _headline2.copyWith(color: _textLight),
      displaySmall: _headline3.copyWith(color: _textLight),
      bodyLarge: _bodyText1.copyWith(color: _textLight),
      bodyMedium: _bodyText2.copyWith(color: _textLight),
      labelLarge: _buttonText.copyWith(color: Colors.white),
      bodySmall: _caption.copyWith(color: _hintLight),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: _primaryLight,
      unselectedItemColor: Colors.grey,
      elevation: 4,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _primaryDark,
    colorScheme: const ColorScheme.dark(
      primary: _primaryDark,
      secondary: _secondaryDark,
      surface: _surfaceDark,
      background: _backgroundDark,
      error: _errorDark,
    ),
    scaffoldBackgroundColor: _backgroundDark,
    appBarTheme: const AppBarTheme(
      color: _surfaceDark,
      elevation: 0,
      iconTheme: IconThemeData(color: _textDark),
      titleTextStyle: TextStyle(
        color: _textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: _surfaceDark,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: _primaryDark,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: _buttonText.copyWith(color: _textDark),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _secondaryDark,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _secondaryDark,
        side: const BorderSide(color: _secondaryDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _secondaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _errorDark),
      ),
      filled: true,
      fillColor: _surfaceDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    textTheme: TextTheme(
      displayLarge: _headline1.copyWith(color: _textDark),
      displayMedium: _headline2.copyWith(color: _textDark),
      displaySmall: _headline3.copyWith(color: _textDark),
      bodyLarge: _bodyText1.copyWith(color: _textDark),
      bodyMedium: _bodyText2.copyWith(color: _textDark),
      labelLarge: _buttonText.copyWith(color: _textDark),
      bodySmall: _caption.copyWith(color: _hintDark),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _surfaceDark,
      selectedItemColor: _secondaryDark,
      unselectedItemColor: Colors.grey,
      elevation: 4,
    ),
  );

  // Additional custom styles
  static BoxDecoration get cardDecorationLight => BoxDecoration(
        color: _surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static BoxDecoration get cardDecorationDark => BoxDecoration(
        color: _surfaceDark,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static TextStyle get priceTextStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _primaryLight,
      );

  static TextStyle get carTitleTextStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get carDetailTextStyle => const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      );
}
