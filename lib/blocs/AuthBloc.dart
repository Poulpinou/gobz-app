import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/configurations/StorageKeysConfig.dart';
import 'package:gobz_app/models/User.dart';
import 'package:gobz_app/models/enums/AuthStatus.dart';
import 'package:gobz_app/models/requests/LoginRequest.dart';
import 'package:gobz_app/repositories/AuthRepository.dart';
import 'package:gobz_app/repositories/UserRepository.dart';
import 'package:gobz_app/utils/LocalStorageUtils.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  late StreamSubscription<AuthStatus> _authStatusSubscription;

  AuthBloc(
      {required AuthRepository authRepository,
      required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthState.unknown()) {
    _authStatusSubscription = _authRepository.statusStream.listen(
      (status) => add(AuthStatusChanged(status)),
    );
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthStatusChanged) {
      yield await _mapAuthStatusChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      _authRepository.logout();
    } else if (event is AuthAutoReconnectRequested) {
      yield* _attemptAutoReconnect();
    }
  }

  Future<AuthState> _mapAuthStatusChangedToState(
      AuthStatusChanged event) async {
    switch (event.status) {
      case AuthStatus.UNAUTHENTICATED:
        return const AuthState.unauthenticated();
      case AuthStatus.AUTHENTICATED:
        final user = await _userRepository.getCurrentUser();
        return user != null
            ? AuthState.authenticated(user)
            : const AuthState.unauthenticated();
      default:
        return const AuthState.unknown();
    }
  }

  Stream<AuthState> _attemptAutoReconnect() async* {
    Log.info("Auto connection requested");

    yield AuthState.authenticating();

    final String? email = await LocalStorageUtils.getString(
        StorageKeysConfig.instance.currentUserEmailKey);

    final String? password = await LocalStorageUtils.getString(
        StorageKeysConfig.instance.currentUserPasswordKey);

    if (email == null || password == null) {
      await LocalStorageUtils.setBool(
          StorageKeysConfig.instance.wasConnectedKey, false);
      yield AuthState.unauthenticated();
    } else {
      try {
        await _authRepository.login(LoginRequest(email, password));
        final user = await _userRepository.getCurrentUser();
        yield user != null
            ? AuthState.authenticated(user)
            : const AuthState.unauthenticated();
      } catch (e) {
        Log.error("Auto reconnection failed", e);
        await LocalStorageUtils.setBool(
            StorageKeysConfig.instance.wasConnectedKey, false);
        yield const AuthState.unauthenticated();
      }
    }
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    _authRepository.dispose();
    return super.close();
  }
}

// Events
abstract class AuthEvent {
  const AuthEvent();
}

class AuthStatusChanged extends AuthEvent {
  const AuthStatusChanged(this.status);

  final AuthStatus status;
}

class AuthAutoReconnectRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

// States
class AuthState {
  final AuthStatus status;
  final User user;

  const AuthState._({this.status = AuthStatus.UNKNOWN, this.user = User.empty});

  const AuthState.unknown() : this._();

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.AUTHENTICATED, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.UNAUTHENTICATED);

  const AuthState.authenticating() : this._(status: AuthStatus.AUTHENTICATING);
}
