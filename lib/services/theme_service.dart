import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeMode {
  light,
  dark,
  system,
  highContrast,
  oceanBlue,
  midnightPurple,
}

class AppTheme {
  final String id;
  final String name;
  final ThemeData themeData;

  AppTheme({required this.id, required this.name, required this.themeData});
}

class ThemeService extends ChangeNotifier {
  AppThemeMode _currentMode = AppThemeMode.dark;

  AppThemeMode get currentMode => _currentMode;

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFE50914), // Netflix Red
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFE50914),
      secondary: Color(0xFF141414),
      surface: Colors.white,
      error: Color(0xFFB00020),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
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
  );

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFE50914),
    scaffoldBackgroundColor: const Color(0xFF141414), // Netflix Black
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFE50914),
      secondary: Colors.white,
      surface: Color(0xFF1F1F1F),
      error: Color(0xFFCF6679),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static final _oceanBlueTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF00E5FF),
    scaffoldBackgroundColor: const Color(0xFF001F29),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00E5FF),
      secondary: Color(0xFFFFD740), // Amber accent
      surface: Color(0xFF003344),
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
  );

  static final _midnightPurpleTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF9D4EDD),
    scaffoldBackgroundColor: const Color(0xFF10002B),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9D4EDD),
      secondary: Color(0xFFE0AAFF),
      surface: Color(0xFF240046),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  );

  ThemeData getTheme() {
    switch (_currentMode) {
      case AppThemeMode.light:
        return _lightTheme;
      case AppThemeMode.dark:
        return _darkTheme;
      case AppThemeMode.oceanBlue:
        return _oceanBlueTheme;
      case AppThemeMode.midnightPurple:
        return _midnightPurpleTheme;
      case AppThemeMode.system:
        return _darkTheme; // Default to dark for system for now
      default:
        return _darkTheme;
    }
  }

  void setTheme(AppThemeMode mode) {
    _currentMode = mode;
    notifyListeners();
  }
}
