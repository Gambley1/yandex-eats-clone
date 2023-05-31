import 'package:flutter/foundation.dart' show immutable;
import 'package:formz/formz.dart' show FormzInput;

@immutable
class OptionalPassword
    extends FormzInput<String, OptionalPasswordValidationError> {
  const OptionalPassword.unvalidated([
    super.value = '',
  ]) : super.pure();

  const OptionalPassword.validated([
    super.value = '',
  ]) : super.dirty();

  @override
  OptionalPasswordValidationError? validator(String value) {
    return value.isEmpty
        ? null
        : (value.length >= 5 && value.length <= 120
            ? null
            : OptionalPasswordValidationError.invalid);
  }
}

enum OptionalPasswordValidationError {
  invalid,
}
