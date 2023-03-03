import 'dart:convert';

class PlaceDetails {
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

  PlaceDetails({
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

  factory PlaceDetails.empty() {
    return PlaceDetails(
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
          ? List<AddressComponents>.from(
              (json['address_components']).map<AddressComponents>(
                (json) => AddressComponents.fromJson(json),
              ),
            )
          : [],
      name: json['name'] as String,
      adrAddress: json['adr_address'] as String,
      formattedAddress: json['formatted_address'] as String,
      geometry: Geometry.fromJson(json['geometry']),
      placeId: json['place_id'] as String,
      reference: json['reference'] as String,
      types: json['types'] != null ? List<String>.from(json['types']) : [],
      url: json['url'],
      utcOffset: json['utc_offset'],
      vicinity: json['vicinity'],
    );
  }

  String toJson() => json.encode(toMap());
}

class AddressComponents {
  final String longName;
  final String shortName;
  final List<String> types;

  AddressComponents({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'longName': longName,
      'shortName': shortName,
      'types': types,
    };
  }

  String toJson() => json.encode(toMap());

  factory AddressComponents.empty() {
    return AddressComponents(longName: '', shortName: '', types: []);
  }

  factory AddressComponents.fromJson(Map<String, dynamic> json) {
    return AddressComponents(
      longName: json['long_name'] as String,
      shortName: json['short_name'] as String,
      types: json['types'] != null ? List<String>.from(json['types']) : [],
    );
  }
}

class Geometry {
  final Location location;
  final Viewport viewport;

  Geometry({
    required this.location,
    required this.viewport,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location.toMap(),
      'viewport': viewport.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Geometry.empty() {
    return Geometry(location: Location.empty(), viewport: Viewport.empty());
  }

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: Location.fromJson(json['location']),
      viewport: Viewport.fromJson(json['viewport']),
    );
  }
}

class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lng': lng,
    };
  }

  String toJson() => json.encode(toMap());

  factory Location.empty() {
    return Location(lat: 0, lng: 0);
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }
}

class Viewport {
  final Northeast northeast;
  final Southwest southwest;

  Viewport({
    required this.northeast,
    required this.southwest,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'northeast': northeast.toMap(),
      'southwest': southwest.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Viewport.empty() {
    return Viewport(northeast: Northeast.empty(), southwest: Southwest.empty());
  }

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: Northeast.fromJson(json['northeast']),
      southwest: Southwest.fromJson(json['southwest']),
    );
  }
}

class Northeast {
  final double lat;
  final double lng;

  Northeast({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lng': lng,
    };
  }

  String toJson() => json.encode(toMap());

  factory Northeast.empty() {
    return Northeast(lat: 0, lng: 0);
  }

  factory Northeast.fromJson(Map<String, dynamic> json) {
    return Northeast(
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }
}

class Southwest {
  final double lat;
  final double lng;

  Southwest({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lng': lng,
    };
  }

  String toJson() => json.encode(toMap());

  factory Southwest.empty() {
    return Southwest(lat: 0, lng: 0);
  }

  factory Southwest.fromJson(Map<String, dynamic> json) {
    return Southwest(
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }
}
