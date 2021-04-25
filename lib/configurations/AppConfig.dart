import 'package:flutter/material.dart';
import 'package:gobz_app/configurations/GobzClientConfig.dart';

class AppConfig {
  final String title;
  final GobzClientConfig gobzClientConfig;

  AppConfig({gobzClientConfig, title})
      : this.title = title ?? "Gobz",
        this.gobzClientConfig = gobzClientConfig ?? GobzClientConfig();

  factory AppConfig.base() => AppConfig();

  static AppConfig _instance = AppConfig.base();

  static AppConfig get instance {
    return _instance;
  }

  factory AppConfig.create(AppConfig config) {
    _instance = config;

    return _instance;
  }
}
