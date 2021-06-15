import 'package:formz/formz.dart';
import 'package:gobz_app/data/models/Step.dart';

import '../InputError.dart';

class RunStepInput extends FormzInput<Step?, InputError> {
  const RunStepInput.pure({Step? defaultValue}) : super.pure(defaultValue);

  const RunStepInput.dirty(Step? step) : super.dirty(step);

  @override
  InputError? validator(Step? value) {
    return value != null ? null : InputError.empty();
  }
}
