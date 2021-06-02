import 'package:formz/formz.dart';

import '../InputError.dart';

class ChapterDescriptionInput extends FormzInput<String, InputError> {
  const ChapterDescriptionInput.pure({String? chapterDescription}) : super.pure(chapterDescription ?? '');

  const ChapterDescriptionInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return null;
  }
}
