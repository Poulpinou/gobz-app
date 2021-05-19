import 'package:flutter/material.dart';
import 'package:gobz_app/themes/AppThemes.dart';

class DarkTheme extends CustomTheme {
  final ThemeData _data;

  DarkTheme() : this._data = ThemeData.dark().copyWith();

  @override
  ThemeData get data => _data;
}
