extension StringExtension on String {
  String capitalized() => '${this[0].toUpperCase()}${substring(1)}';
}
