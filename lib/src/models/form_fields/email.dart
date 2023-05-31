import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:formz/formz.dart' show FormzInput;

@immutable
class Email extends FormzInput<String, EmailValidationError>
    with EquatableMixin {
  const Email.unvalidated([
    super.value = '',
  ])  : isAlreadyRegistered = false,
        super.pure();

  const Email.validated(
    super.value, {
    this.isAlreadyRegistered = false,
  }) : super.dirty();

  static final _emailRegex = RegExp(
    r'^(([\w-]+\.)+[\w-]+|([a-zA-Z]|[\w-]{2,}))@((([0-1]?'
    r'[0-9]{1,2}|25[0-5]|2[0-4][0-9])\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\.'
    r'([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])'
    r')|([a-zA-Z]+[\w-]+\.)+[a-zA-Z]{2,4})$',
  );

  final bool isAlreadyRegistered;

  @override
  EmailValidationError? validator(String value) {
    return value.isEmpty
        ? EmailValidationError.empty
        : (isAlreadyRegistered
            ? EmailValidationError.alreadyRegistered
            : (_emailRegex.hasMatch(value)
                ? null
                : EmailValidationError.invalid));
  }

  @override
  List<Object> get props => [
        value,
        isAlreadyRegistered,
        pure,
      ];
}

enum EmailValidationError {
  empty,
  invalid,
  alreadyRegistered,
}
