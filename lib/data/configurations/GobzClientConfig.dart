import 'package:gobz_app/data/configurations/AppConfig.dart';

class GobzClientConfig {
  final String host;
  final bool logRequests;
  final String accessTokenStorageKey;
  final Duration? fakeWait;

  const GobzClientConfig(
      {this.host = "10.0.2.2:8080",
      this.logRequests = false,
      this.accessTokenStorageKey = "gobzApiAccessToken",
      this.fakeWait});

  static GobzClientConfig get instance => AppConfig.instance.gobzClientConfig;
}
