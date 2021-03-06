import 'package:formz/formz.dart';

import '../InputError.dart';
import 'PasswordInput.dart';

class PasswordRepeatInput extends FormzInput<String, InputError> {
  final PasswordInput? passwordInput;

  const PasswordRepeatInput.pure()
      : this.passwordInput = null,
        super.pure('');

  const PasswordRepeatInput.dirty(String value, this.passwordInput) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    if (passwordInput != null && passwordInput!.invalid) {
      return InputError("Mot de passe invalide");
    }

    if (passwordInput == null || value == null || value.isEmpty == true) {
      return InputError("Vous devez confirmer le mot de passe");
    }

    return passwordInput!.value == value ? null : InputError("Les mots de passe ne correspondent pas");
  }
}
