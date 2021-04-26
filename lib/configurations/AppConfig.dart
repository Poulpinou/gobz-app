import 'package:gobz_app/configurations/GobzClientConfig.dart';
import 'package:gobz_app/configurations/StorageKeysConfig.dart';

class AppConfig {
  final String title;
  final GobzClientConfig gobzClientConfig;
  final StorageKeysConfig storageKeysConfig;

  const AppConfig(
      {this.title = "Gobz",
      this.gobzClientConfig = const GobzClientConfig(),
      this.storageKeysConfig = const StorageKeysConfig()});

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
