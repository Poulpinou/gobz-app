import 'package:flutter/material.dart';

import 'AppThemes.dart';

class LightTheme extends CustomTheme {
  final ThemeData _data;

  LightTheme() : this._data = ThemeData.dark().copyWith();

  @override
  ThemeData get data => _data;
}
