// ignore_for_file: public_member_api_docs

extension StringExtension on String {
  String capitalized() => '${this[0].toUpperCase()}${substring(1)}';
  bool trimmedContains(String other) => trim().toLowerCase().contains(
        other.trim().toLowerCase(),
      );
}
