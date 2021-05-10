import 'package:formz/formz.dart';
import 'package:gobz_app/widgets/forms/generics/inputs/InputError.dart';

class TaskTextInput extends FormzInput<String, InputError> {
  const TaskTextInput.pure({String? taskText}) : super.pure(taskText ?? '');

  const TaskTextInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return value?.isNotEmpty == true ? null : InputError.empty();
  }
}
