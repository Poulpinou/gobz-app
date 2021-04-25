import 'package:formz/formz.dart';

enum UsernameValidationError { empty }

class UsernameInput extends FormzInput<String, UsernameValidationError> {
  const UsernameInput.pure() : super.pure('');
  const UsernameInput.dirty([String value = '']) : super.dirty(value);

  @override
  UsernameValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : UsernameValidationError.empty;
  }
}