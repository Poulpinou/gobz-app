import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/configurations/StorageKeysConfig.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/formInputs/auth/EmailInput.dart';
import 'package:gobz_app/data/formInputs/auth/PasswordInput.dart';
import 'package:gobz_app/data/models/BlocState.dart';
import 'package:gobz_app/data/models/requests/LoginRequest.dart';
import 'package:gobz_app/data/repositories/AuthRepository.dart';
import 'package:gobz_app/data/utils/LocalStorageUtils.dart';

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
      yield state.copyWith(formStatus: FormzStatus.submissionInProgress, isLoading: true);
      try {
        await _authRepository.login(LoginRequest(state.email.value, state.password.value));

        // Store current user infos
        await LocalStorageUtils.setBool(StorageKeysConfig.instance.stayConnectedKey, state.stayConnected);
        await LocalStorageUtils.setString(StorageKeysConfig.instance.currentUserEmailKey, state.email.value);
        await LocalStorageUtils.setString(StorageKeysConfig.instance.currentUserPasswordKey, state.password.value);

        yield state.copyWith(formStatus: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.copyWith(
          formStatus: FormzStatus.submissionFailure,
          error: e is DisplayableException
              ? e
              : DisplayableException(
                  "L'authentification a échoué",
                  errorMessage: "Login failed",
                  error: e is Exception ? e : null,
                ),
        );
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
class LoginState extends BlocState with FormzMixin {
  final FormzStatus formStatus;
  final EmailInput email;
  final PasswordInput password;
  final bool stayConnected;
  final bool localValuesLoaded;

  const LoginState(
      {bool? isLoading,
      Exception? error,
      this.formStatus = FormzStatus.pure,
      this.email = const EmailInput.pure(),
      this.password = const PasswordInput.pure(),
      this.stayConnected = false,
      this.localValuesLoaded = false})
      : super(isLoading: isLoading, error: error);

  @override
  List<FormzInput> get inputs => [email, password];

  LoginState copyWith(
          {bool? isLoading,
          Exception? error,
          FormzStatus? formStatus,
          EmailInput? email,
          PasswordInput? password,
          bool? stayConnected,
          bool? localValuesLoaded}) =>
      LoginState(
          isLoading: isLoading ?? false,
          error: error,
          formStatus: formStatus ?? this.status,
          email: email ?? this.email,
          password: password ?? this.password,
          stayConnected: stayConnected ?? this.stayConnected,
          localValuesLoaded: localValuesLoaded ?? this.localValuesLoaded);
}
