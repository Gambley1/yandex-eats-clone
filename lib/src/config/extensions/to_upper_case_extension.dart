extension ToUpperCaseExtension on String {
  String firstCapitalUpper() => '${this[0].toUpperCase()}${substring(1)}';
}
