import 'package:formz/formz.dart';
import 'package:gobz_app/widgets/forms/generics/inputs/InputError.dart';

class ProjectDescriptionInput extends FormzInput<String, InputError> {
  const ProjectDescriptionInput.pure({String? projectDescription}) : super.pure(projectDescription ?? '');

  const ProjectDescriptionInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return null;
  }
}
