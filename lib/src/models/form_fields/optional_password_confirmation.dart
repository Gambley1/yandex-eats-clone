import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:formz/formz.dart' show FormzInput;
import 'package:papa_burger/src/restaurant.dart' show OptionalPassword;

@immutable
class OptionalPasswordConfirmation
    extends FormzInput<String, OptionalPasswordConfirmationValidationError>
    with EquatableMixin {
  const OptionalPasswordConfirmation.unvalidated([
    super.value = '',
  ])  : password = const OptionalPassword.unvalidated(),
        super.pure();

  const OptionalPasswordConfirmation.validated(
    super.value, {
    required this.password,
  }) : super.dirty();

  final OptionalPassword password;

  @override
  OptionalPasswordConfirmationValidationError? validator(String value) {
    return value.isEmpty
        ? (password.value.isEmpty
            ? null
            : OptionalPasswordConfirmationValidationError.empty)
        : (value == password.value
            ? null
            : OptionalPasswordConfirmationValidationError.invalid);
  }

  @override
  List<Object?> get props => [value, password, pure];
}

enum OptionalPasswordConfirmationValidationError {
  empty,
  invalid,
}
