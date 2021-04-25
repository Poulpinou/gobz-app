import 'package:formz/formz.dart';

enum EmailValidationError { empty, wrongFormat }

class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure() : super.pure('');

  const EmailInput.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return EmailValidationError.empty;
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!)) {
      return EmailValidationError.wrongFormat;
    }

    return null;
  }

  static String getMessageFromError(EmailValidationError error){
    switch (error) {
      case EmailValidationError.empty:
        return "Veuillez entrer une adresse email";
      case EmailValidationError.wrongFormat:
        return "Format de l'email invalide";
      default:
        return "Email invalide";
    }
  }
}
