import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../InputError.dart';

class RunLimitDateInput extends FormzInput<DateTime?, InputError> {
  const RunLimitDateInput.pure({DateTime? defaultValue}) : super.pure(defaultValue);

  const RunLimitDateInput.dirty(DateTime? limitDate) : super.dirty(limitDate);

  bool get hasLimitDate => value != null;

  @override
  InputError? validator(DateTime? value) {
    if(value == null){
      // don't check if null
      return null;
    }

    final DateTime now = DateTime.now();
    if (value.isBefore(now)) {
      return InputError("Ne peut pas être antérieure à la date actuelle");
    }

    return null;
  }
}
