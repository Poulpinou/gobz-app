import 'dart:convert';
import 'dart:io';

import 'package:gobz_app/data/exceptions/UnreachableServerException.dart';
import 'package:gobz_app/data/exceptions/api/BadRequestException.dart';
import 'package:gobz_app/data/exceptions/api/FetchDataException.dart';
import 'package:gobz_app/data/exceptions/api/UnauthorisedException.dart';
import 'package:gobz_app/data/utils/LoggingUtils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class ApiClient {
  final String baseUrl;
  final bool logRequests;
  final Duration? fakeWait;

  static const Map<String, String> defaultHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  ApiClient({
    required this.baseUrl,
    this.logRequests = false,
    this.fakeWait,
  });

  /// Override this method to provide custom Uri
  Uri buildUri(String? path) => Uri.http(baseUrl, path ?? "");

  /// Override this method to provide custom Headers
  Future<Map<String, String>> buildHeaders() async => defaultHeaders;

  /// Override this method to provide a custom way to handle responses
  dynamic buildResponse(Response response) {
    if (logRequests) {
      Log.info("Responded with status ${response.statusCode}");
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(utf8.decode(response.body.codeUnits));
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.statusCode, response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          response.statusCode,
          'Error occured while communication with server"',
        );
    }
  }

  Future<dynamic> sendRequest(Future<Response> request) async {
    if (fakeWait != null) {
      await Future.delayed(fakeWait!);
    }

    try {
      final Response response = await request;
      return buildResponse(response);
    } on SocketException {
      throw UnreachableServerException();
    }
  }

  Future<dynamic> get(String? path) async {
    final Uri uri = buildUri(path);
    if (logRequests) Log.info("GET ${uri.path}");

    return sendRequest(http.get(uri, headers: await buildHeaders()));
  }

  Future<dynamic> post(String path, {dynamic? body}) async {
    final Uri uri = buildUri(path);
    if (logRequests) Log.info("POST ${uri.path} ${body != null ? "with body: $body" : ""}");

    return sendRequest(http.post(uri, headers: await buildHeaders(), body: json.encode(body)));
  }

  Future<dynamic> put(String path, {dynamic? body}) async {
    final Uri uri = buildUri(path);
    if (logRequests) Log.info("PUT ${uri.path} ${body != null ? "with body: $body" : ""}");

    return sendRequest(http.put(uri, headers: await buildHeaders(), body: json.encode(body)));
  }

  Future<dynamic> patch(String path, {dynamic? body}) async {
    final Uri uri = buildUri(path);
    if (logRequests) Log.info("PATCH ${uri.path} ${body != null ? "with body: $body" : ""}");

    return sendRequest(http.patch(uri, headers: await buildHeaders(), body: json.encode(body)));
  }

  Future<dynamic> delete(String path) async {
    final Uri uri = buildUri(path);
    if (logRequests) Log.info("DELETE ${uri.path}");

    return sendRequest(http.delete(uri, headers: await buildHeaders()));
  }
}
