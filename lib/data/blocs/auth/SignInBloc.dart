import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/formInputs/auth/EmailInput.dart';
import 'package:gobz_app/data/formInputs/auth/PasswordInput.dart';
import 'package:gobz_app/data/formInputs/auth/PasswordValidationInput.dart';
import 'package:gobz_app/data/formInputs/auth/UsernameInput.dart';
import 'package:gobz_app/data/models/requests/SignInRequest.dart';
import 'package:gobz_app/data/repositories/AuthRepository.dart';

import '../EditionBlocState.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;

  SignInBloc(this._authRepository) : super(const SignInState());

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is _SignInUsernameChanged) {
      yield state.copyWith(username: UsernameInput.dirty(event.username));
    } else if (event is _SignInEmailChanged) {
      yield state.copyWith(email: EmailInput.dirty(event.email));
    } else if (event is _SignInPasswordChanged) {
      yield state.copyWith(password: PasswordInput.dirty(event.password));
    } else if (event is _SignInPasswordRepeatChanged) {
      yield state.copyWith(repeatPassword: PasswordRepeatInput.dirty(event.passwordRepeat, state.password));
    } else if (event is _SignInSubmitted) {
      yield* _onFormSubmitted(state);
    }
  }

  Stream<SignInState> _onFormSubmitted(SignInState state) async* {
    if (state.status.isValidated) {
      yield state.formSubmitting();
      try {
        await _authRepository.signIn(SignInRequest(state.username.value, state.email.value, state.password.value));

        yield state.copyWith(formStatus: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.formSubmissionFailed(
          DisplayableException(
            "La création du compte a échoué",
            errorMessage: "Sign in failed",
            error: e as Exception,
          ),
        );
      }
    }
  }
}

// Events
abstract class SignInEvent {}

abstract class SignInEvents {
  static _SignInUsernameChanged usernameChanged(String username) => _SignInUsernameChanged(username);

  static _SignInEmailChanged emailChanged(String email) => _SignInEmailChanged(email);

  static _SignInPasswordChanged passwordChanged(String password) => _SignInPasswordChanged(password);

  static _SignInPasswordRepeatChanged passwordRepeatChanged(String passwordRepeat) =>
      _SignInPasswordRepeatChanged(passwordRepeat);

  static _SignInSubmitted signInSubmitted() => _SignInSubmitted();
}

class _SignInUsernameChanged extends SignInEvent {
  final String username;

  _SignInUsernameChanged(this.username);
}

class _SignInEmailChanged extends SignInEvent {
  final String email;

  _SignInEmailChanged(this.email);
}

class _SignInPasswordChanged extends SignInEvent {
  final String password;

  _SignInPasswordChanged(this.password);
}

class _SignInPasswordRepeatChanged extends SignInEvent {
  final String passwordRepeat;

  _SignInPasswordRepeatChanged(this.passwordRepeat);
}

class _SignInSubmitted extends SignInEvent {}

// State
class SignInState extends EditionBlocState {
  final UsernameInput username;
  final EmailInput email;
  final PasswordInput password;
  final PasswordRepeatInput repeatPassword;

  const SignInState(
      {Exception? error,
      FormzStatus formStatus = FormzStatus.pure,
      this.username = const UsernameInput.pure(),
      this.email = const EmailInput.pure(),
      this.password = const PasswordInput.pure(),
      this.repeatPassword = const PasswordRepeatInput.pure()})
      : super(formStatus: formStatus, error: error);

  @override
  List<FormzInput> get inputs => [username, email, password];

  SignInState copyWith(
          {bool? isLoading,
          Exception? error,
          FormzStatus? formStatus,
          UsernameInput? username,
          EmailInput? email,
          PasswordInput? password,
          PasswordRepeatInput? repeatPassword}) =>
      SignInState(
          error: error,
          formStatus: formStatus ?? this.status,
          username: username ?? this.username,
          email: email ?? this.email,
          password: password ?? this.password,
          repeatPassword: repeatPassword ?? this.repeatPassword);
}
