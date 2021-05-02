import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const Color mainColor = Color(0xFF313335);
  static const Color secondaryColor = Color(0xFF3C3F41);
  static const Color backgroundColor = Color(0xFF2B2B2B);
  static const Color white = Color(0xFFAEB0B2);

  static final ThemeData main = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: mainColor,
    accentColor: secondaryColor,
    scaffoldBackgroundColor: backgroundColor,
    primaryTextTheme: GoogleFonts.latoTextTheme(),
    appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 4,
        titleTextStyle: TextStyle(color: white, fontWeight: FontWeight.bold)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: mainColor,
    ),
  );

  static final ThemeData dark = ThemeData.dark().copyWith();

  static final ThemeData light = ThemeData.light().copyWith();
}
