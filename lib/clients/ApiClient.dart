import 'dart:convert';
import 'dart:io';

import 'package:gobz_app/exceptions/BadRequestException.dart';
import 'package:gobz_app/exceptions/FetchDataException.dart';
import 'package:gobz_app/exceptions/UnauthorisedException.dart';
import 'package:gobz_app/utils/LocalStorageUtils.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiClient {
  final String host;
  final String? basePath;
  final bool logRequests;
  final bool withBearerToken;
  final String accessTokenStorageKey;
  final Map<String, String> headers;

  static const Map<String, String> defaultHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  ApiClient(this.host,
      {this.basePath,
      this.logRequests = false,
      this.withBearerToken = false,
      this.accessTokenStorageKey = "accessToken",
      this.headers = defaultHeaders});

  dynamic _returnResponse(Response response) {
    Log.info("Responded with status ${response.statusCode}");
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body.toString());
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server with StatusCode : ${response.statusCode}');
    }
  }

  Future<Map<String, String>> _buildHeaders() async {
    final Map<String, String> finalHeaders = Map.from(headers);

    if (withBearerToken) {
      await LocalStorageUtils.getString(accessTokenStorageKey)
          .then((token) =>
              finalHeaders[HttpHeaders.authorizationHeader] = "Bearer $token")
          .onError((error, stackTrace) {
        Log.warning("Failed to retrieve token in local storage: $error");
        return "none";
      });
    }

    return finalHeaders;
  }

  String _buildPath(String path) {
    String finalPath = path;
    if (basePath != null) {
      finalPath = basePath! + finalPath;
    }

    return finalPath;
  }

  Future<dynamic> get(String path) async {
    final Uri uri = Uri.http(host, _buildPath(path));
    if (logRequests) Log.info("GET ${uri.path}");

    var responseJson;
    try {
      final Response response =
          await http.get(uri, headers: await _buildHeaders());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> post(String path, {dynamic? body}) async {
    final Uri uri = Uri.http(host, _buildPath(path));
    if (logRequests) Log.info("POST ${uri.path} with body: $body");

    var responseJson;
    try {
      final Response response = await http.post(uri,
          headers: await _buildHeaders(), body: json.encode(body));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String path, {dynamic? body}) async {
    final Uri uri = Uri.http(host, _buildPath(path));
    if (logRequests) Log.info("PUT ${uri.path}");

    var responseJson;
    try {
      final Response response = await http.put(uri,
          headers: await _buildHeaders(), body: json.encode(body));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> patch(String path, {dynamic? body}) async {
    final Uri uri = Uri.http(host, _buildPath(path));
    if (logRequests) Log.info("PATCH ${uri.path}");

    var responseJson;
    try {
      final Response response = await http.patch(uri,
          headers: await _buildHeaders(), body: json.encode(body));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String path) async {
    final Uri uri = Uri.http(host, _buildPath(path));
    if (logRequests) Log.info("DELETE ${uri.path}");

    var responseJson;
    try {
      final Response response =
          await http.delete(uri, headers: await _buildHeaders());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
}
