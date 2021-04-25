import 'dart:async';
import 'dart:convert';

import 'package:gobz_app/clients/ApiClient.dart';
import 'package:gobz_app/configurations/GobzClientConfig.dart';
import 'package:gobz_app/models/enums/AuthStatus.dart';
import 'package:gobz_app/models/requests/SignInRequest.dart';
import 'package:gobz_app/utils/LocalStorageUtils.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class AuthRepository {
  final StreamController<AuthStatus> _controller =
      StreamController<AuthStatus>();
  final ApiClient _client = ApiClient(GobzClientConfig.instance.host,
      basePath: "/auth", logRequests: GobzClientConfig.instance.logRequests);

  Stream<AuthStatus> get statusStream async* {
    yield AuthStatus.UNAUTHENTICATED;
    yield* _controller.stream;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    Log.info("Trying to log user in with $email...");
    final Map<String, dynamic> responseData = await _client.post("/login",
        body: {"email": email, "password": password});

    // TODO: Handle errors
    final String accessToken = responseData["accessToken"];
    await LocalStorageUtils.setString(
        GobzClientConfig.instance.accessTokenStorageKey, accessToken);

    _controller.add(AuthStatus.AUTHENTICATED);
    Log.info("$email successfully logged in");
  }

  Future<void> signIn(SignInRequest request) async {
    Log.info("Trying to create user account for ${request.name} with ${request.email}...");

    await _client.post("/signup", body: request.toJson());

    Log.info("${request.name}'s acccount created successfully");
    
    login(email: request.email, password: request.password);
  }

  Future<void> logout() async {
    await LocalStorageUtils.removeKey(
        GobzClientConfig.instance.accessTokenStorageKey);

    _controller.add(AuthStatus.UNAUTHENTICATED);
  }

  void dispose() => _controller.close();
}
