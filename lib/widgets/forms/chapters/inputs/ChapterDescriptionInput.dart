import 'package:formz/formz.dart';
import 'package:gobz_app/widgets/forms/generics/inputs/InputError.dart';

class ChapterDescriptionInput extends FormzInput<String, InputError> {
  const ChapterDescriptionInput.pure({String? chapterDescription}) : super.pure(chapterDescription ?? '');

  const ChapterDescriptionInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return null;
  }
}
