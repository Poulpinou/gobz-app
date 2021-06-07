import 'package:formz/formz.dart';

import '../InputError.dart';

class PasswordInput extends FormzInput<String, InputError> {
  const PasswordInput.pure() : super.pure('');

  const PasswordInput.dirty(String value) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return value?.isNotEmpty == true ? null : InputError.empty();
  }
}
