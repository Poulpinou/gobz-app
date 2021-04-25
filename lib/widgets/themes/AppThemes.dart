import 'package:flutter/material.dart';

class AppThemes {
  static final Color mainColor = Colors.blueGrey;

  static final ThemeData main = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      //primarySwatch: MaterialColor(),
      primaryColor: mainColor);
}
