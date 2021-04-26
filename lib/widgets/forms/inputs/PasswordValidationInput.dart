import 'package:formz/formz.dart';
import 'package:gobz_app/widgets/forms/inputs/PasswordInput.dart';

enum PasswordRepeatInputError { empty, notMatching, passwordInvalid }

class PasswordRepeatInput extends FormzInput<String, PasswordRepeatInputError> {
  final PasswordInput? passwordInput;

  const PasswordRepeatInput.pure()
      : this.passwordInput = null,
        super.pure('');

  const PasswordRepeatInput.dirty(String value, this.passwordInput)
      : super.dirty(value);

  @override
  PasswordRepeatInputError? validator(String? value) {
    if (passwordInput != null && passwordInput!.invalid) {
      return PasswordRepeatInputError.passwordInvalid;
    }

    if (passwordInput == null || value == null || value.isEmpty == true) {
      return PasswordRepeatInputError.empty;
    }

    return passwordInput!.value == value
        ? null
        : PasswordRepeatInputError.notMatching;
  }

  static String getMessageFromError(PasswordRepeatInputError error) {
    switch (error) {
      case PasswordRepeatInputError.empty:
        return "Vous devez confirmer le mot de passe";
      case PasswordRepeatInputError.notMatching:
        return "Les mots de passe ne correspondent pas";
      case PasswordRepeatInputError.passwordInvalid:
        return "Mot de passe invalide";
    }
  }
}
