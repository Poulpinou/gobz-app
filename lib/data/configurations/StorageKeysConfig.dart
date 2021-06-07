import 'package:gobz_app/data/configurations/AppConfig.dart';

class StorageKeysConfig {
  final String stayConnectedKey;
  final String wasConnectedKey;
  final String currentUserEmailKey;
  final String currentUserPasswordKey;

  const StorageKeysConfig(
      {this.stayConnectedKey = "stayConnected",
      this.wasConnectedKey = "wasConnected",
      this.currentUserEmailKey = "userEmail",
      this.currentUserPasswordKey = "userPassword"});

  static StorageKeysConfig get instance => AppConfig.instance.storageKeysConfig;
}
