import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/configurations/StorageKeysConfig.dart';
import 'package:gobz_app/models/requests/LoginRequest.dart';
import 'package:gobz_app/repositories/AuthRepository.dart';
import 'package:gobz_app/utils/LocalStorageUtils.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';
import 'package:gobz_app/widgets/forms/auth/inputs/EmailInput.dart';
import 'package:gobz_app/widgets/forms/auth/inputs/PasswordInput.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(const LoginState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is _LoadLocalValues) {
      yield await _loadLocalValues(state);
    } else if (event is _LoginEmailChanged) {
      yield state.copyWith(email: EmailInput.dirty(event.email));
    } else if (event is _LoginPasswordChanged) {
      yield state.copyWith(password: PasswordInput.dirty(event.password));
    } else if (event is _StayConnectedChanged) {
      yield state.copyWith(stayConnected: event.stayConnected);
    } else if (event is _LoginSubmitted) {
      yield* _onFormSubmitted(state);
    }
  }

  Future<LoginState> _loadLocalValues(LoginState state) async {
    final bool? stayConnected = await LocalStorageUtils.getBool(StorageKeysConfig.instance.stayConnectedKey);
    final String? email = await LocalStorageUtils.getString(StorageKeysConfig.instance.currentUserEmailKey);
    final String? password = await LocalStorageUtils.getString(StorageKeysConfig.instance.currentUserPasswordKey);

    return state.copyWith(
        stayConnected: stayConnected,
        email: email != null ? EmailInput.dirty(email) : null,
        password: password != null ? PasswordInput.dirty(password) : null,
        localValuesLoaded: true);
  }

  Stream<LoginState> _onFormSubmitted(LoginState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(formStatus: FormzStatus.submissionInProgress);
      try {
        await _authRepository.login(LoginRequest(state.email.value, state.password.value));

        // Store current user infos
        await LocalStorageUtils.setBool(StorageKeysConfig.instance.stayConnectedKey, state.stayConnected);
        await LocalStorageUtils.setString(StorageKeysConfig.instance.currentUserEmailKey, state.email.value);
        await LocalStorageUtils.setString(StorageKeysConfig.instance.currentUserPasswordKey, state.password.value);

        yield state.copyWith(formStatus: FormzStatus.submissionSuccess);
      } catch (e) {
        Log.error("Login failed", e);
        yield state.copyWith(formStatus: FormzStatus.submissionFailure);
      }
    }
  }
}

// Events
abstract class LoginEvent {}

abstract class LoginEvents {
  static _LoadLocalValues loadLocalValues() => _LoadLocalValues();

  static _LoginEmailChanged emailChanged(String email) => _LoginEmailChanged(email);

  static _LoginPasswordChanged passwordChanged(String password) => _LoginPasswordChanged(password);

  static _StayConnectedChanged stayConnectedChanged(bool stayConnected) => _StayConnectedChanged(stayConnected);

  static _LoginSubmitted loginSubmitted() => _LoginSubmitted();
}

class _LoadLocalValues extends LoginEvent {}

class _LoginEmailChanged extends LoginEvent {
  final String email;

  _LoginEmailChanged(this.email);
}

class _LoginPasswordChanged extends LoginEvent {
  final String password;

  _LoginPasswordChanged(this.password);
}

class _StayConnectedChanged extends LoginEvent {
  final bool stayConnected;

  _StayConnectedChanged(this.stayConnected);
}

class _LoginSubmitted extends LoginEvent {}

// States
class LoginState with FormzMixin {
  final FormzStatus formStatus;
  final EmailInput email;
  final PasswordInput password;
  final bool stayConnected;
  final bool localValuesLoaded;

  const LoginState(
      {this.formStatus = FormzStatus.pure,
      this.email = const EmailInput.pure(),
      this.password = const PasswordInput.pure(),
      this.stayConnected = false,
      this.localValuesLoaded = false});

  @override
  List<FormzInput> get inputs => [email, password];

  LoginState copyWith(
          {FormzStatus? formStatus,
          EmailInput? email,
          PasswordInput? password,
          bool? stayConnected,
          bool? localValuesLoaded}) =>
      LoginState(
          formStatus: formStatus ?? this.status,
          email: email ?? this.email,
          password: password ?? this.password,
          stayConnected: stayConnected ?? this.stayConnected,
          localValuesLoaded: localValuesLoaded ?? this.localValuesLoaded);
}
