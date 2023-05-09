import 'package:flutter/material.dart';

extension ToUpperCaseExtension on String {
  String firstCapitalUpper() =>
      '${characters.first.toUpperCase()}${characters.getRange(1, length)}';
}
