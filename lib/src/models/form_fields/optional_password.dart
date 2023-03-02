import 'package:formz/formz.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class OptionalPassword
    extends FormzInput<String, OptionalPasswordValidationError> {
  const OptionalPassword.unvalidated([
    String value = '',
  ]) : super.pure(value);

  const OptionalPassword.validated([
    String value = '',
  ]) : super.dirty(value);

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
