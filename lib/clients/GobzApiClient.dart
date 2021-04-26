import 'dart:io';

import 'package:gobz_app/clients/ApiClient.dart';
import 'package:gobz_app/configurations/GobzClientConfig.dart';
import 'package:gobz_app/utils/LocalStorageUtils.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class GobzApiClient extends ApiClient {
  final String? basePath;
  final bool withBearerToken;

  GobzApiClient({this.basePath, this.withBearerToken = true})
      : super(GobzClientConfig.instance.host,
            logRequests: GobzClientConfig.instance.logRequests);

  @override
  Uri buildUri(String? path) => Uri.http(baseUrl, "$basePath$path");

  @override
  Future<Map<String, String>> buildHeaders() async {
    final Map<String, String> finalHeaders =
        Map.from(await super.buildHeaders());

    if (withBearerToken) {
      final String? token = await LocalStorageUtils.getString(
          GobzClientConfig.instance.accessTokenStorageKey);

      if (token != null) {
        finalHeaders[HttpHeaders.authorizationHeader] = "Bearer $token";
      } else {
        Log.warning("Failed to retrieve token in local storage");
      }
    }

    return finalHeaders;
  }
}
