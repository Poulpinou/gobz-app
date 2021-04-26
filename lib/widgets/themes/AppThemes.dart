import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const Color mainColor = Color(0xFFFF9436);
  static const Color secondaryColor = Color(0xFFEABF79);
  static const Color white = Color(0xFFFFFFFF);

  static final ThemeData main = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: mainColor,
    accentColor: secondaryColor,
    primaryTextTheme: GoogleFonts.latoTextTheme(),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 4,
      titleTextStyle: TextStyle(
        color: white,
        fontWeight: FontWeight.bold
      )
    ),
  );
}
