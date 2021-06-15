import 'package:formz/formz.dart';
import 'package:gobz_app/data/formInputs/InputError.dart';
import 'package:gobz_app/data/models/Task.dart';

class RunTaskListInput extends FormzInput<List<Task>?, InputError> {
  const RunTaskListInput.pure({List<Task>? defaultValue}) : super.pure(defaultValue);

  const RunTaskListInput.dirty(List<Task>? value) : super.dirty(value);

  @override
  InputError? validator(List<Task>? value) {
    return value?.isNotEmpty == true ? null : InputError.empty();
  }
}
