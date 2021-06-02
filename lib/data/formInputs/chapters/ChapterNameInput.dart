import 'package:formz/formz.dart';

import '../InputError.dart';

class ChapterNameInput extends FormzInput<String, InputError> {
  const ChapterNameInput.pure({String? chapterName}) : super.pure(chapterName ?? '');

  const ChapterNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  InputError? validator(String? value) {
    return value?.isNotEmpty == true ? null : InputError.empty();
  }
}
