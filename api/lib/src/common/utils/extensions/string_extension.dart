extension StringExtension on String {
  String capitalized() => '${this[0].toUpperCase()}${substring(1)}';

  String replaceAllSpacesToLowerCase() =>
      trim().toLowerCase().replaceAll(' ', '');

  bool trimmedContains(String other) => trim()
      .replaceAllSpacesToLowerCase()
      .contains(other.replaceAllSpacesToLowerCase());

  int intParse() => int.parse(this);
  int? intTryParse() => int.tryParse(this);

  double doubleParse() => double.parse(this);
  double? doubleTryParse() => double.tryParse(this);
}

extension StringNullableExtension on String? {
  int intParse() => this == null ? 0 : int.parse(this!);
  int? intTryParse() => this == null ? null : int.tryParse(this!);

  double doubleParse() => this == null ? 0 : double.parse(this!);
  double? doubleTryParse() => this == null ? null : double.tryParse(this!);
}
