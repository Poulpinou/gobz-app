import 'package:formz/formz.dart';

import '../InputError.dart';

class StepDescriptionInput extends FormzInput<String, InputError> {
  const StepDescriptionInput.pure({String? stepDescription}) : super.pure(stepDescription ?? '');

  const StepDescriptionInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return null;
  }
}
