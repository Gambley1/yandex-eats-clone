import 'package:flutter/material.dart';
import 'package:yandex_food_api/client.dart';

@immutable
class PlaceDetails {
  const PlaceDetails({
    required this.name,
    required this.formattedAddress,
    required this.placeId,
    required this.url,
    required this.location,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      name: json['name'] as String,
      formattedAddress: json['formatted_address'] as String,
      placeId: json['place_id'] as String,
      url: json['url'] as String,
      location: json['geometry'] == null
          ? const Location.undefined()
          : Location.fromJson(
              (json['geometry'] as Map<String, dynamic>)['location']!
                  as Map<String, dynamic>,
            ),
    );
  }

  final String name;
  final String formattedAddress;
  final String placeId;
  final String url;
  final Location location;

  Map<String, dynamic> toJson() => {
        'name': name,
        'formatted_address': formattedAddress,
        'placeId': placeId,
        'url': url,
        'location': location.toJson(),
      };
}
