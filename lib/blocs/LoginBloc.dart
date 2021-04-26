import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/configurations/AppConfig.dart';
import 'package:gobz_app/configurations/StorageKeysConfig.dart';
import 'package:gobz_app/models/requests/LoginRequest.dart';
import 'package:gobz_app/repositories/AuthRepository.dart';
import 'package:gobz_app/utils/LocalStorageUtils.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';
import 'package:gobz_app/widgets/forms/inputs/PasswordInput.dart';
import 'package:gobz_app/widgets/forms/inputs/EmailInput.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(const LoginState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoadLocalValues) {
      yield await _loadLocalValues(event, state);
    } else if (event is LoginEmailChanged) {
      yield state.copyWith(email: EmailInput.dirty(event.email));
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: PasswordInput.dirty(event.password));
    } else if (event is StayConnectedChanged) {
      yield state.copyWith(stayConnected: event.stayConnected);
    } else if (event is LoginSubmitted) {
      yield* _onFormSubmitted(event, state);
    }
  }

  Future<LoginState> _loadLocalValues(
      LoadLocalValues event, LoginState state) async {
    final bool? stayConnected = await LocalStorageUtils.getBool(
        StorageKeysConfig.instance.stayConnectedKey);
    final String? email = await LocalStorageUtils.getString(
        StorageKeysConfig.instance.currentUserEmailKey);
    final String? password = await LocalStorageUtils.getString(
        StorageKeysConfig.instance.currentUserPasswordKey);

    return state.copyWith(
        stayConnected: stayConnected,
        email: email != null ? EmailInput.dirty(email) : null,
        password: password != null ? PasswordInput.dirty(password) : null,
        localValuesLoaded: true);
  }

  Stream<LoginState> _onFormSubmitted(
      LoginSubmitted event, LoginState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(formStatus: FormzStatus.submissionInProgress);
      try {
        await _authRepository
            .login(LoginRequest(state.email.value, state.password.value));

        // Store current user infos
        await LocalStorageUtils.setBool(
            StorageKeysConfig.instance.stayConnectedKey, state.stayConnected);
        await LocalStorageUtils.setString(
            StorageKeysConfig.instance.currentUserEmailKey, state.email.value);
        await LocalStorageUtils.setString(
            StorageKeysConfig.instance.currentUserPasswordKey,
            state.password.value);

        yield state.copyWith(formStatus: FormzStatus.submissionSuccess);
      } on Exception catch (e) {
        Log.error("Login failed", e);
        yield state.copyWith(formStatus: FormzStatus.submissionFailure);
      }
    }
  }
}

// Events
abstract class LoginEvent {
  const LoginEvent();
}

class LoadLocalValues extends LoginEvent {
  const LoadLocalValues();
}

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;
}

class StayConnectedChanged extends LoginEvent {
  const StayConnectedChanged(this.stayConnected);

  final bool stayConnected;
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

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
