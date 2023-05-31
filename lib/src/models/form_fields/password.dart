import 'package:flutter/foundation.dart' show immutable;
import 'package:formz/formz.dart' show FormzInput;

@immutable
class Password extends FormzInput<String, PasswordValidationError> {
  const Password.unvalidated([
    super.value = '',
  ]) : super.pure();

  const Password.validated([
    super.value = '',
  ]) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 5 || value.length > 120) {
      return PasswordValidationError.invalid;
    } else {
      return null;
    }
  }
}

enum PasswordValidationError {
  empty,
  invalid,
}
