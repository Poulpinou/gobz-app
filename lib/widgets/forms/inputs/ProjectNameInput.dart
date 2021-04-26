import 'package:formz/formz.dart';
import 'package:gobz_app/widgets/forms/inputs/InputError.dart';

class ProjectNameInput extends FormzInput<String, InputError> {
  const ProjectNameInput.pure() : super.pure('');
  const ProjectNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return value?.isNotEmpty == true ? null : InputError.empty();
  }
}
