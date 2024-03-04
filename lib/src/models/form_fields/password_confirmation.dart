import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:formz/formz.dart' show FormzInput;
import 'package:papa_burger/src/models/models.dart';

@immutable
class PasswordConfirmation
    extends FormzInput<String, PasswordConfirmationValidationError>
    with EquatableMixin {
  const PasswordConfirmation.unvalidated([
    super.value = '',
  ])  : password = const Password.unvalidated(),
        super.pure();

  const PasswordConfirmation.validated(
    super.value, {
    required this.password,
  }) : super.dirty();

  final Password password;

  @override
  PasswordConfirmationValidationError? validator(String value) {
    return value.isEmpty
        ? PasswordConfirmationValidationError.empty
        : (value == password.value
            ? null
            : PasswordConfirmationValidationError.invalid);
  }

  @override
  List<Object?> get props => [value, password, pure];
}

enum PasswordConfirmationValidationError {
  empty,
  invalid,
}
