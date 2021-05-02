import 'package:formz/formz.dart';
import 'package:gobz_app/widgets/forms/generics/inputs/InputError.dart';

class ProjectSearchInput extends FormzInput<String, InputError> {
  const ProjectSearchInput.pure() : super.pure('');

  const ProjectSearchInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    if (value?.isEmpty == true) {
      return InputError.empty();
    }

    return null;
  }
}
