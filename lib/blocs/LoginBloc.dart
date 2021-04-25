import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/repositories/AuthRepository.dart';
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
    if (event is LoginEmailChanged) {
      yield state.copyWith(email: EmailInput.dirty(event.email));
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: PasswordInput.dirty(event.password));
    } else if (event is LoginSubmitted) {
      yield* _onFormSubmitted(event, state);
    }
  }

  Stream<LoginState> _onFormSubmitted(
    LoginSubmitted event,
    LoginState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(formStatus: FormzStatus.submissionInProgress);
      try {
        await _authRepository.login(
          email: state.email.value,
          password: state.password.value,
        );
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

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

// States
class LoginState with FormzMixin {
  final FormzStatus formStatus;
  final EmailInput email;
  final PasswordInput password;

  const LoginState(
      {this.formStatus = FormzStatus.pure,
      this.email = const EmailInput.pure(),
      this.password = const PasswordInput.pure()});

  @override
  List<FormzInput> get inputs => [email, password];

  LoginState copyWith({
    FormzStatus? formStatus,
    EmailInput? email,
    PasswordInput? password,
  }) =>
      LoginState(
          formStatus: formStatus ?? this.status,
          email: email ?? this.email,
          password: password ?? this.password);
}
