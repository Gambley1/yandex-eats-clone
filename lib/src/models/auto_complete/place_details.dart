import 'dart:convert' show json;

import 'package:flutter/material.dart';

@immutable
class PlaceDetails {
  const PlaceDetails({
    required this.addressComponents,
    required this.name,
    required this.adrAddress,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.reference,
    required this.types,
    required this.url,
    required this.utcOffset,
    required this.vicinity,
  });

  factory PlaceDetails.empty() {
    return const PlaceDetails(
      addressComponents: [],
      name: '',
      adrAddress: '',
      formattedAddress: '',
      geometry: Geometry.empty(),
      placeId: '',
      reference: '',
      types: [],
      url: '',
      utcOffset: 0,
      vicinity: '',
    );
  }

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      addressComponents: json['address_components'] != null
          ? List<dynamic>.from(
              json['address_components'] as List,
            )
              .map((e) => AddressComponents.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      name: json['name'] as String,
      adrAddress: json['adr_address'] as String,
      formattedAddress: json['formatted_address'] as String,
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      placeId: json['place_id'] as String,
      reference: json['reference'] as String,
      types: json['types'] != null
          ? List<dynamic>.from(json['types'] as List).cast<String>()
          : [],
      url: json['url'] as String,
      utcOffset: json['utc_offset'] as int,
      vicinity: json['vicinity'] as String,
    );
  }
  final List<AddressComponents> addressComponents;
  final String name;
  final String adrAddress;
  final String formattedAddress;
  final Geometry geometry;
  final String placeId;
  final String reference;
  final List<String> types;
  final String url;
  final int utcOffset;
  final String vicinity;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address_components': addressComponents.map((x) => x.toMap()).toList(),
      'name': name,
      'adr_address': adrAddress,
      'formatted_address': formattedAddress,
      'geometry': geometry.toMap(),
      'placeId': placeId,
      'reference': reference,
      'types': types,
      'url': url,
      'utcOffset': utcOffset,
      'vicinity': vicinity,
    };
  }

  String toJson() => json.encode(toMap());
}

@immutable
class AddressComponents {
  const AddressComponents({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponents.empty() {
    return const AddressComponents(longName: '', shortName: '', types: []);
  }

  factory AddressComponents.fromJson(Map<String, dynamic> json) {
    return AddressComponents(
      longName: json['long_name'] as String,
      shortName: json['short_name'] as String,
      types: json['types'] != null
          ? List<dynamic>.from(json['types'] as List).cast<String>()
          : [],
    );
  }
  final String longName;
  final String shortName;
  final List<String> types;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'long_name': longName,
      'short_name': shortName,
      'types': types,
    };
  }

  String toJson() => json.encode(toMap());
}

@immutable
class Geometry {
  const Geometry({
    required this.location,
    required this.viewport,
  });

  const Geometry.empty()
      : location = const Location.empty(),
        viewport = const Viewport.empty();

  factory Geometry.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Geometry.empty();
    }
    return Geometry(
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      viewport: Viewport.fromJson(json['viewport'] as Map<String, dynamic>),
    );
  }
  final Location location;
  final Viewport viewport;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location.toMap(),
      'viewport': viewport.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

@immutable
class Location {
  const Location({
    required this.lat,
    required this.lng,
  });

  const Location.empty()
      : lat = 0,
        lng = 0;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }
  final double lat;
  final double lng;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lng': lng,
    };
  }

  String toJson() => json.encode(toMap());
}

@immutable
class Viewport {
  const Viewport({
    required this.northeast,
    required this.southwest,
  });

  const Viewport.empty()
      : northeast = const Northeast.empty(),
        southwest = const Southwest.empty();

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: Northeast.fromJson(json['northeast'] as Map<String, dynamic>),
      southwest: Southwest.fromJson(json['southwest'] as Map<String, dynamic>),
    );
  }
  final Northeast northeast;
  final Southwest southwest;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'northeast': northeast.toMap(),
      'southwest': southwest.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

@immutable
class Northeast {
  const Northeast({
    required this.lat,
    required this.lng,
  });

  const Northeast.empty()
      : lat = 0,
        lng = 0;

  factory Northeast.fromJson(Map<String, dynamic> json) {
    return Northeast(
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }
  final double lat;
  final double lng;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lng': lng,
    };
  }

  String toJson() => json.encode(toMap());
}

@immutable
class Southwest {
  const Southwest({
    required this.lat,
    required this.lng,
  });

  const Southwest.empty()
      : lat = 0,
        lng = 0;

  factory Southwest.fromJson(Map<String, dynamic> json) {
    return Southwest(
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }
  final double lat;
  final double lng;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lng': lng,
    };
  }

  String toJson() => json.encode(toMap());
}
