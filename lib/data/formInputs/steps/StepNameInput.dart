import 'package:formz/formz.dart';

import '../InputError.dart';

class StepNameInput extends FormzInput<String, InputError> {
  const StepNameInput.pure({String? stepName}) : super.pure(stepName ?? '');

  const StepNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return value?.isNotEmpty == true ? null : InputError.empty();
  }
}
