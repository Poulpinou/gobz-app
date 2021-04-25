import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/models/User.dart';
import 'package:gobz_app/models/enums/AuthStatus.dart';
import 'package:gobz_app/repositories/AuthRepository.dart';
import 'package:gobz_app/repositories/UserRepository.dart';

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

class AuthLogoutRequested extends AuthEvent {}

// States
class AuthState {
  final AuthStatus status;
  final User user;

  const AuthState._({
    this.status = AuthStatus.UNKNOWN,
    this.user = User.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.AUTHENTICATED, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.UNAUTHENTICATED);
}
