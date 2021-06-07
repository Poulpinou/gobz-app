import 'package:flutter/material.dart';

import 'DarkTheme.dart';
import 'LightTheme.dart';

class AppThemes {
  static final ThemeData light = LightTheme().data;
  static final ThemeData dark = DarkTheme().data;
}

abstract class CustomTheme {
  ThemeData get data;
}
