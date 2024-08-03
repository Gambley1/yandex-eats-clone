// ignore_for_file: lines_longer_than_80_chars

class Address {
  const Address({
    this.street,
    this.locality,
    this.country,
  });

  final String? street;
  final String? locality;
  final String? country;

  Address copyWith({String? street, String? locality, String? country}) =>
      Address(
        street: street ?? this.street,
        locality: locality ?? this.locality,
        country: country ?? this.country,
      );

  @override
  String toString() {
    if (street == null && locality == null && country == null) return '';
    return '${street == null ? '' : '$street${locality == null && country == null ? '' : ','}'} '
        '${locality == null ? '' : '$locality,'} ${country ?? ''}';
  }
}
