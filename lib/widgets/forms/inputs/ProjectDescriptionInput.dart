import 'package:formz/formz.dart';

import 'InputError.dart';

class ProjectDescriptionInput extends FormzInput<String, InputError> {
  const ProjectDescriptionInput.pure() : super.pure('');

  const ProjectDescriptionInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return null;
  }
}
