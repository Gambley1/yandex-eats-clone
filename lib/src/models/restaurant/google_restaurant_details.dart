// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:papa_burger/src/restaurant.dart'
    show AddressComponents, Geometry, PlusCode;

class GoogleRestaurantDetails {
  List<AddressComponents> addressComponents;
  String adrAddress;
  String businessStatus;
  CurrentOpeningHours currentOpeningHours;
  bool? delivery;
  bool? dineIn;
  String formattedAddress;
  String formattedPhoneNumber;
  Geometry geometry;
  String icon;
  String iconBackgroundColor;
  String iconMaskBaseUri;
  String internationalPhoneNumber;
  String name;
  CurrentOpeningHours openingHours;
  List<Photos> photos;
  String placeId;
  PlusCode plusCode;
  int? priceLevel;
  double? rating;
  String reference;
  bool? reservable;
  List<Reviews> reviews;
  bool? servesBeer;
  bool? servesBreakfast;
  bool? servesDinner;
  bool? servesLunch;
  bool? servesWine;
  bool? takeout;
  List<String> types;
  String url;
  int userRatingsTotal;
  int utcOffset;
  String vicinity;
  String? website;

  GoogleRestaurantDetails({
    required this.addressComponents,
    required this.adrAddress,
    required this.businessStatus,
    required this.currentOpeningHours,
    required this.delivery,
    required this.dineIn,
    required this.formattedAddress,
    required this.formattedPhoneNumber,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.internationalPhoneNumber,
    required this.name,
    required this.openingHours,
    required this.photos,
    required this.placeId,
    required this.plusCode,
    required this.priceLevel,
    required this.rating,
    required this.reference,
    required this.reservable,
    required this.reviews,
    required this.servesBeer,
    required this.servesBreakfast,
    required this.servesDinner,
    required this.servesLunch,
    required this.servesWine,
    required this.takeout,
    required this.types,
    required this.url,
    required this.userRatingsTotal,
    required this.utcOffset,
    required this.vicinity,
    required this.website,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address_components': addressComponents.map((x) => x.toMap()).toList(),
      'adr_address': adrAddress,
      'business_status': businessStatus,
      'current_opening_hours': currentOpeningHours.toMap(),
      'delivery': delivery,
      'dine_in': dineIn,
      'formatted_address': formattedAddress,
      'formatted_phone_number': formattedPhoneNumber,
      'geometry': geometry.toMap(),
      'icon': icon,
      'icon_background_color': iconBackgroundColor,
      'icon_mask_base_uri': iconMaskBaseUri,
      'international_phone_number': internationalPhoneNumber,
      'name': name,
      'opening_hours': openingHours.toMap(),
      'photos': photos.map((x) => x.toMap()).toList(),
      'place_id': placeId,
      'plus_code': plusCode.toMap(),
      'price_level': priceLevel,
      'rating': rating,
      'reference': reference,
      'reservable': reservable,
      'reviews': reviews.map((x) => x.toMap()).toList(),
      'serves_beer': servesBeer,
      'serves_breakfast': servesBreakfast,
      'serves_dinner': servesDinner,
      'serves_lunch': servesLunch,
      'serves_wine': servesWine,
      'takeout': takeout,
      'types': types,
      'url': url,
      'user_ratings_total': userRatingsTotal,
      'utc_offset': utcOffset,
      'vicinity': vicinity,
      'website': website,
    };
  }

  factory GoogleRestaurantDetails.fromJson(Map<String, dynamic> json) {
    return GoogleRestaurantDetails(
      addressComponents: json['address_components'] != null
          ? List<AddressComponents>.from(
              (json['address_components']).map<AddressComponents>(
                (json) => AddressComponents.fromJson(json),
              ),
            )
          : [],
      adrAddress: json['adr_address'] as String,
      businessStatus: json['business_status'] as String,
      currentOpeningHours:
          CurrentOpeningHours.fromJson(json['current_opening_hours']),
      delivery: json['delivery'] as bool?,
      dineIn: json['dine_in'] as bool?,
      formattedAddress: json['formatted_address'] as String,
      formattedPhoneNumber: json['formatted_phone_number'] as String,
      geometry: Geometry.fromJson(json['geometry']),
      icon: json['icon'] as String,
      iconBackgroundColor: json['icon_background_color'] as String,
      iconMaskBaseUri: json['icon_mask_base_uri'] as String,
      internationalPhoneNumber: json['international_phone_number'] as String,
      name: json['name'] as String,
      openingHours: CurrentOpeningHours.fromJson(json['opening_hours']),
      photos: json['photos'] != null
          ? List<Photos>.from(
              (json['photos']).map<Photos>(
                (json) => Photos.fromJson(json),
              ),
            )
          : [],
      placeId: json['place_id'] as String,
      plusCode: PlusCode.fromJson(json['plus_code']),
      priceLevel: json['price_level'] as int?,
      rating: json['rating'] as double?,
      reference: json['reference'] as String,
      reservable: json['reservable'] as bool?,
      reviews: json['photos'] != null
          ? List<Reviews>.from(
              (json['photos']).map<Reviews>(
                (json) => Reviews.fromJson(json),
              ),
            )
          : [],
      servesBeer: json['serves_beer'] as bool?,
      servesBreakfast: json['serves_breakfast'] as bool?,
      servesDinner: json['serves_dinner'] as bool?,
      servesLunch: json['serves_lunch'] as bool?,
      servesWine: json['serves_wine'] as bool?,
      takeout: json['takeout'] as bool?,
      types: json['types'] != null ? List<String>.from(
        (json['types']),
      ) : [],
      url: json['url'] as String,
      userRatingsTotal: json['user_ratings_total'] as int,
      utcOffset: json['utc_offset'] as int,
      vicinity: json['vicinity'] as String,
      website: json['website'] as String?,
    );
  }

  String toJson() => json.encode(toMap());
}

class CurrentOpeningHours {
  bool openNow;
  List<Periods> periods;
  List<String> weekdayText;

  CurrentOpeningHours({
    required this.openNow,
    required this.periods,
    required this.weekdayText,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'open_now': openNow,
      'periods': periods.map((x) => x.toMap()).toList(),
      'weekday_text': weekdayText,
    };
  }

  factory CurrentOpeningHours.fromJson(Map<String, dynamic> json) {
    return CurrentOpeningHours(
      openNow: json['open_now'] as bool,
      periods: List<Periods>.from(
        (json['periods']).map<Periods>(
          (json) => Periods.fromJson(json),
        ),
      ),
      weekdayText: List<String>.from(
        (json['weekday_text']),
      ),
    );
  }

  String toJson() => json.encode(toMap());
}

class Photos {
  int height;
  List<String> htmlAttributions;
  String photoReference;
  int width;

  Photos({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'height': height,
      'html_attributions': htmlAttributions,
      'photo_reference': photoReference,
      'width': width,
    };
  }

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
      height: json['height'] as int,
      htmlAttributions: List<String>.from(
        (json['html_attributions']),
      ),
      photoReference: json['photo_reference'] as String,
      width: json['width'] as int,
    );
  }

  String toJson() => json.encode(toMap());
}

class Periods {
  Close close;
  Open open;

  Periods({
    required this.close,
    required this.open,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'close': close.toMap(),
      'open': open.toMap(),
    };
  }

  factory Periods.fromJson(Map<String, dynamic> json) {
    return Periods(
      close: Close.fromJson(json['close']),
      open: Open.fromJson(json['open']),
    );
  }

  String toJson() => json.encode(toMap());
}

class Close {
  String? date;
  int day;
  String time;
  bool? truncated;

  Close({
    this.date,
    required this.day,
    required this.time,
    this.truncated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'day': day,
      'time': time,
      'truncated': truncated,
    };
  }

  factory Close.fromJson(Map<String, dynamic> json) {
    return Close(
      date: json['date'] != null ? json['date'] as String : null,
      day: json['day'] as int,
      time: json['time'] as String,
      truncated: json['truncated'] != null ? json['truncated'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());
}

class Open {
  String? date;
  int day;
  String time;
  bool? truncated;

  Open({
    required this.date,
    required this.day,
    required this.time,
    this.truncated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'day': day,
      'time': time,
      'truncated': truncated,
    };
  }

  factory Open.fromJson(Map<String, dynamic> json) {
    return Open(
      date: json['date'] != null ? json['date'] as String : null,
      day: json['day'] as int,
      time: json['time'] as String,
      truncated: json['truncated'] != null ? json['truncated'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());
}

class Reviews {
  String? authorName;
  String? authorUrl;
  String? language;
  String? originalLanguage;
  String? profilePhotoUrl;
  int? rating;
  String? relativeTimeDescription;
  String? text;
  int? time;
  bool? translated;

  Reviews({
    this.authorName,
    this.authorUrl,
    this.language,
    this.originalLanguage,
    this.profilePhotoUrl,
    this.rating,
    this.relativeTimeDescription,
    this.text,
    this.time,
    this.translated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author_name': authorName,
      'author_url': authorUrl,
      'language': language,
      'original_language': originalLanguage,
      'profile_photo_url': profilePhotoUrl,
      'rating': rating,
      'relative_time_description': relativeTimeDescription,
      'text': text,
      'time': time,
      'translated': translated,
    };
  }

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      authorName: json['author_name'] ?? '',
      authorUrl: json['author_url'] ?? '',
      language: json['language'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      profilePhotoUrl: json['profile_photo_url'] ?? '',
      rating: json['rating'] ?? 0,
      relativeTimeDescription: json['relative_time_description'] ?? '',
      text: json['text'] ?? '',
      time: json['time'] ?? 0,
      translated: json['translated'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());
}
