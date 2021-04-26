import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/models/requests/SignInRequest.dart';
import 'package:gobz_app/repositories/AuthRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';
import 'package:gobz_app/widgets/forms/inputs/EmailInput.dart';
import 'package:gobz_app/widgets/forms/inputs/PasswordInput.dart';
import 'package:gobz_app/widgets/forms/inputs/PasswordValidationInput.dart';
import 'package:gobz_app/widgets/forms/inputs/UsernameInput.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;

  SignInBloc(this._authRepository) : super(const SignInState());

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is SignInUsernameChanged) {
      yield state.copyWith(username: UsernameInput.dirty(event.username));
    } else if (event is SignInEmailChanged) {
      yield state.copyWith(email: EmailInput.dirty(event.email));
    } else if (event is SignInPasswordChanged) {
      yield state.copyWith(password: PasswordInput.dirty(event.password));
    } else if (event is SignInPasswordRepeatChanged) {
      yield state.copyWith(
          repeatPassword:
              PasswordRepeatInput.dirty(event.passwordRepeat, state.password));
    } else if (event is SignInSubmitted) {
      yield* _onFormSubmitted(event, state);
    }
  }

  Stream<SignInState> _onFormSubmitted(
      SignInSubmitted event, SignInState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(formStatus: FormzStatus.submissionInProgress);
      try {
        await _authRepository.signIn(SignInRequest(
            state.username.value, state.email.value, state.password.value));

        yield state.copyWith(formStatus: FormzStatus.submissionSuccess);
      } on Exception catch (e) {
        Log.error("Sign in failed", e);
        yield state.copyWith(formStatus: FormzStatus.submissionFailure);
      }
    }
  }
}

// Events
abstract class SignInEvent {
  const SignInEvent();
}

class SignInUsernameChanged extends SignInEvent {
  const SignInUsernameChanged(this.username);

  final String username;
}

class SignInEmailChanged extends SignInEvent {
  const SignInEmailChanged(this.email);

  final String email;
}

class SignInPasswordChanged extends SignInEvent {
  const SignInPasswordChanged(this.password);

  final String password;
}

class SignInPasswordRepeatChanged extends SignInEvent {
  const SignInPasswordRepeatChanged(this.passwordRepeat);

  final String passwordRepeat;
}

class SignInSubmitted extends SignInEvent {
  const SignInSubmitted();
}

// State
class SignInState with FormzMixin {
  final FormzStatus formStatus;
  final UsernameInput username;
  final EmailInput email;
  final PasswordInput password;
  final PasswordRepeatInput repeatPassword;

  const SignInState(
      {this.formStatus = FormzStatus.pure,
      this.username = const UsernameInput.pure(),
      this.email = const EmailInput.pure(),
      this.password = const PasswordInput.pure(),
      this.repeatPassword = const PasswordRepeatInput.pure()});

  @override
  List<FormzInput> get inputs => [username, email, password];

  SignInState copyWith(
          {FormzStatus? formStatus,
          UsernameInput? username,
          EmailInput? email,
          PasswordInput? password,
          PasswordRepeatInput? repeatPassword}) =>
      SignInState(
          formStatus: formStatus ?? this.status,
          username: username ?? this.username,
          email: email ?? this.email,
          password: password ?? this.password,
          repeatPassword: repeatPassword ?? this.repeatPassword);
}
