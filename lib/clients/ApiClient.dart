import 'dart:convert';
import 'dart:io';

import 'package:gobz_app/exceptions/BadRequestException.dart';
import 'package:gobz_app/exceptions/FetchDataException.dart';
import 'package:gobz_app/exceptions/UnauthorisedException.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class ApiClient {
  final String baseUrl;

  final bool logRequests;

  static const Map<String, String> defaultHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  ApiClient(this.baseUrl, {this.logRequests = false});

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

  Future<dynamic> get(String? path) async {
    final Uri uri = buildUri(path);
    if (logRequests) Log.info("GET ${uri.path}");

    var responseJson;
    try {
      final Response response =
          await http.get(uri, headers: await buildHeaders());
      responseJson = buildResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> post(String path, {dynamic? body}) async {
    final Uri uri = buildUri(path);
    if (logRequests) Log.info("POST ${uri.path} with body: $body");

    var responseJson;
    try {
      final Response response = await http.post(uri,
          headers: await buildHeaders(), body: json.encode(body));
      responseJson = buildResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String path, {dynamic? body}) async {
    final Uri uri = buildUri(path);
    if (logRequests) Log.info("PUT ${uri.path}");

    var responseJson;
    try {
      final Response response = await http.put(uri,
          headers: await buildHeaders(), body: json.encode(body));
      responseJson = buildResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> patch(String path, {dynamic? body}) async {
    final Uri uri = buildUri(path);
    if (logRequests) Log.info("PATCH ${uri.path}");

    var responseJson;
    try {
      final Response response = await http.patch(uri,
          headers: await buildHeaders(), body: json.encode(body));
      responseJson = buildResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String path) async {
    final Uri uri = buildUri(path);
    if (logRequests) Log.info("DELETE ${uri.path}");

    var responseJson;
    try {
      final Response response =
          await http.delete(uri, headers: await buildHeaders());
      responseJson = buildResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
}
