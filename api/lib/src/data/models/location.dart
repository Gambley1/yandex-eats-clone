import 'package:equatable/equatable.dart';

/// Location class
class Location extends Equatable {
  /// {@macro location}
  const Location({
    required this.lat,
    required this.lng,
  });

  const Location.undefiend() : this(lat: 0, lng: 0);

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json['lat'] as double,
        lng: json['lng'] as double,
      );

  Location copyWith({double? lat, double? lng}) =>
      Location(lat: lat ?? this.lat, lng: lng ?? this.lng);

  /// Associated lat
  final double lat;

  /// Associated lng
  final double lng;

  bool get isUndefiend => lat == 0 && lng == 0;

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  @override
  List<Object?> get props => [lat, lng];
}
