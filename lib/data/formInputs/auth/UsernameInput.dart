import 'package:formz/formz.dart';

import '../InputError.dart';

class UsernameInput extends FormzInput<String, InputError> {
  const UsernameInput.pure() : super.pure('');

  const UsernameInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return value?.isNotEmpty == true ? null : InputError.empty();
  }
}
