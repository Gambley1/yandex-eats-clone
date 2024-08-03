import 'package:equatable/equatable.dart' show EquatableMixin;
import 'package:flutter/foundation.dart' show immutable;
import 'package:form_fields/form_fields.dart';
import 'package:formz/formz.dart' show FormzInput;

/// {@template name}
/// Form input for a name. It extends [FormzInput] and uses
/// [UsernameValidationError] for its validation errors.
/// {@endtemplate}
@immutable
class Username extends FormzInput<String, UsernameValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro name.pure}
  const Username.pure([super.value = '']) : super.pure();

  /// {@macro name.dirty}
  const Username.dirty(super.value) : super.dirty();

  static final _nameRegex = RegExp(r'^[a-zA-Z0-9_\.\u0400-\u04FF]{3,16}$');

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    if (!_nameRegex.hasMatch(value)) return UsernameValidationError.invalid;
    return null;
  }

  @override
  Map<UsernameValidationError?, String?> get validationErrorMessage => {
        UsernameValidationError.empty: 'This field is required',
        UsernameValidationError.invalid:
            'Username must be between 3 and 16 characters. Also, it can only '
                'contain letters, numbers, periods, and underscores.',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [Username]. It can be empty or invalid.
enum UsernameValidationError {
  /// Empty name.
  empty,

  /// Invalid name.
  invalid,
}
