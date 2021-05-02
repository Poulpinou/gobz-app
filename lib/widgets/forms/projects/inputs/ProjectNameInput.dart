import 'package:formz/formz.dart';
import 'package:gobz_app/widgets/forms/generics/inputs/InputError.dart';

class ProjectNameInput extends FormzInput<String, InputError> {
  const ProjectNameInput.pure({String? projectName}) : super.pure(projectName ?? '');

  const ProjectNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return value?.isNotEmpty == true ? null : InputError.empty();
  }
}
