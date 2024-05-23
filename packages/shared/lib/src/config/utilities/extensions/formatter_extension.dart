/*
 * ----------------------------------------------------------------------------
 *
 * This file is part of the metal_bonus_backend project, available at:
 * https://github.com/Gambley1/metal_bonus_backend/
 *
 * Created by: Emil Zulufov
 * ----------------------------------------------------------------------------
 *
 * Copyright (c) 2020 Emil Zulufov
 *
 * Licensed under the MIT License.
 *
 * ----------------------------------------------------------------------------
*/

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final _formatter = NumberFormat();
final _currency = NumberFormat.currency(
  symbol: r'$',
  decimalDigits: 0,
  locale: 'en_US',
);
final _date = DateFormat('HH:mm - dd.MM.yyyy', 'en');
final _patternedDate = DateFormat.yMMMMd('en');

/// Extension for parsing [String] to [num].
extension Parse on String {
  /// Parses [String] to [num].
  num get parse => isEmpty ? 0 : _formatter.parse(clearValue);
}

/// Extension for formatting [String].
extension FormatString on String {
  /// Formats [num] to [String].
  String format({bool separate = true}) =>
      separate ? _formatter.format(parse) : this;

  /// Formats [num] to [String].
  num formatToNum({bool separate = true}) => format(separate: separate).parse;

  /// Returns [String] or empty string if it is null.
  String get stringOrEmpty => isEmpty ? '' : this;

  /// Returns [String] or 0 if it is null.
  String get stringOrZero => isEmpty ? '0' : this;

  /// Returns [String] with currency symbol.
  String currencyFormat() => _currency.format(formatToNum(separate: false));

  /// Displays loading string if [isLoading] is true.
  String isLoadingString({bool isLoading = false}) => isLoading ? '...' : this;
}

/// Extension for formatting [num] to [String].
extension FormatNum on num {
  /// Formats [num] to [String].
  String format({bool separate = true}) =>
      separate ? _formatter.format(this) : toString();

  /// Returns [String] with currency symbol.
  String currencyFormat() => _currency.format(this);
}

/// Extension for formatting [num] to [String].
extension FormatNullable on num? {
  /// Formats [num] to [String].
  String? formatNullable({bool separate = true}) =>
      separate ? _formatter.format(this) : null;

  /// Returns [num] or 0 if it is null.
  num get numberOrZero => this ?? 0;

  /// Returns [String] with currency symbol.
  String currencyFormat() => _currency.format(this);
}

/// Extension for removing all non-digit characters from a string.
extension ClearValue on String {
  /// Removes all non-digits from string.
  String get clearValue => replaceAll(RegExp(r'[^\d]'), '');
}

/// Extension for formatting [DateTime] to [String].
extension DateFormatter on DateTime {
  /// Formats [DateTime] to [String].
  String format({String? pattern}) {
    initializeDateFormatting('en');
    return pattern != null ? _patternedDate.format(this) : _date.format(this);
  }
}
