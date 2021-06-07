import 'package:gobz_app/data/configurations/AppConfig.dart';

class GobzClientConfig {
  final String host;
  final bool logRequests;
  final String accessTokenStorageKey;

  const GobzClientConfig(
      {this.host = "10.0.2.2:8080", this.logRequests = false, this.accessTokenStorageKey = "gobzApiAccessToken"});

  static GobzClientConfig get instance => AppConfig.instance.gobzClientConfig;
}
