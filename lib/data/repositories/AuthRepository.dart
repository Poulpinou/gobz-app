import 'dart:async';

import 'package:gobz_app/data/clients/ApiClient.dart';
import 'package:gobz_app/data/clients/GobzApiClient.dart';
import 'package:gobz_app/data/configurations/GobzClientConfig.dart';
import 'package:gobz_app/data/configurations/StorageKeysConfig.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/exceptions/api/UnauthorisedException.dart';
import 'package:gobz_app/data/models/enums/AuthStatus.dart';
import 'package:gobz_app/data/models/requests/LoginRequest.dart';
import 'package:gobz_app/data/models/requests/SignInRequest.dart';
import 'package:gobz_app/data/utils/LocalStorageUtils.dart';
import 'package:gobz_app/data/utils/LoggingUtils.dart';

class AuthRepository {
  final StreamController<AuthStatus> _controller = StreamController<AuthStatus>();
  final ApiClient _client = GobzApiClient(basePath: "/auth", withBearerToken: false);

  Stream<AuthStatus> get statusStream async* {
    yield AuthStatus.UNAUTHENTICATED;
    yield* _controller.stream;
  }

  Future<void> login(LoginRequest request) async {
    Log.info("Trying to log user in with ${request.email}...");

    final Map<String, dynamic> responseData;
    try {
      responseData = await _client.post("/login", body: request.toJson());
    } on UnauthorisedException catch (e) {
      if (e.statusCode == 401) {
        throw new DisplayableException(
          "Email ou mot de passe incorrect",
          errorMessage: "Invalid credentials",
          error: e,
        );
      } else {
        rethrow;
      }
    }

    final String accessToken = responseData["accessToken"];
    await LocalStorageUtils.setString(GobzClientConfig.instance.accessTokenStorageKey, accessToken);
    await LocalStorageUtils.setBool(StorageKeysConfig.instance.wasConnectedKey, true);

    // Store current user infos
    await LocalStorageUtils.setString(StorageKeysConfig.instance.currentUserEmailKey, request.email);
    await LocalStorageUtils.setString(StorageKeysConfig.instance.currentUserPasswordKey, request.password);

    _controller.add(AuthStatus.AUTHENTICATED);
    Log.info("${request.email} successfully logged in");
  }

  Future<void> signIn(SignInRequest request) async {
    Log.info("Trying to create user account for ${request.name} with ${request.email}...");

    await _client.post("/signup", body: request.toJson());

    Log.info("${request.name}'s acccount created successfully");

    login(LoginRequest(request.email, request.password));
  }

  Future<void> logout() async {
    await LocalStorageUtils.removeKey(GobzClientConfig.instance.accessTokenStorageKey);
    await LocalStorageUtils.setBool(StorageKeysConfig.instance.wasConnectedKey, false);

    Log.info("Successfully logged out");

    _controller.add(AuthStatus.UNAUTHENTICATED);
  }

  void dispose() => _controller.close();
}
