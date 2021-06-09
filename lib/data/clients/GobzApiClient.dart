import 'dart:io';

import 'package:gobz_app/data/configurations/GobzClientConfig.dart';
import 'package:gobz_app/data/utils/LocalStorageUtils.dart';
import 'package:gobz_app/data/utils/LoggingUtils.dart';

import 'ApiClient.dart';

class GobzApiClient extends ApiClient {
  final String? basePath;
  final bool withBearerToken;

  GobzApiClient({this.basePath, this.withBearerToken = true})
      : super(
          baseUrl: GobzClientConfig.instance.host,
          logRequests: GobzClientConfig.instance.logRequests,
          fakeWait: GobzClientConfig.instance.fakeWait,
        );

  @override
  Uri buildUri(String? path) => Uri.http(baseUrl, "${basePath ?? ""}$path");

  @override
  Future<Map<String, String>> buildHeaders() async {
    final Map<String, String> finalHeaders = Map.from(await super.buildHeaders());

    if (withBearerToken) {
      final String? token = await LocalStorageUtils.getString(GobzClientConfig.instance.accessTokenStorageKey);

      if (token != null) {
        finalHeaders[HttpHeaders.authorizationHeader] = "Bearer $token";
      } else {
        Log.warning("Failed to retrieve token in local storage");
      }
    }

    return finalHeaders;
  }
}
