import 'package:formz/formz.dart';

enum ProjectSearchValidationError { empty }

class ProjectSearchInput
    extends FormzInput<String, ProjectSearchValidationError> {
  const ProjectSearchInput.pure(): super.pure('');

  const ProjectSearchInput.dirty([String value = '']) : super.dirty(value);

  @override
  ProjectSearchValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return ProjectSearchValidationError.empty;
    }

    return null;
  }
}
