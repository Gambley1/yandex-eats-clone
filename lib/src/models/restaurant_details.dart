import 'dart:convert' show json;

import 'package:papa_burger/src/models/models.dart';

class RestaurantDetails {
  RestaurantDetails({
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

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) {
    return RestaurantDetails(
      addressComponents: json['address_components'] != null
          ? List<dynamic>.from(
              json['address_components'] as List,
            )
              .map((e) => AddressComponents.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      adrAddress: json['adr_address'] as String,
      businessStatus: json['business_status'] as String,
      currentOpeningHours: CurrentOpeningHours.fromJson(
        json['current_opening_hours'] as Map<String, dynamic>,
      ),
      delivery: json['delivery'] as bool?,
      dineIn: json['dine_in'] as bool?,
      formattedAddress: json['formatted_address'] as String,
      formattedPhoneNumber: json['formatted_phone_number'] as String,
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      icon: json['icon'] as String,
      iconBackgroundColor: json['icon_background_color'] as String,
      iconMaskBaseUri: json['icon_mask_base_uri'] as String,
      internationalPhoneNumber: json['international_phone_number'] as String,
      name: json['name'] as String,
      openingHours: CurrentOpeningHours.fromJson(
        json['opening_hours'] as Map<String, dynamic>,
      ),
      photos: json['photos'] != null
          ? List<dynamic>.from(
              json['photos'] as List,
            ).map((e) => Photos.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      placeId: json['place_id'] as String,
      plusCode: PlusCode.fromJson(json['plus_code'] as Map<String, dynamic>),
      priceLevel: json['price_level'] as int?,
      rating: json['rating'] as double?,
      reference: json['reference'] as String,
      reservable: json['reservable'] as bool?,
      reviews: json['reviews'] != null
          ? List<dynamic>.from(
              json['reviews'] as List,
            ).map((e) => Reviews.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      servesBeer: json['serves_beer'] as bool?,
      servesBreakfast: json['serves_breakfast'] as bool?,
      servesDinner: json['serves_dinner'] as bool?,
      servesLunch: json['serves_lunch'] as bool?,
      servesWine: json['serves_wine'] as bool?,
      takeout: json['takeout'] as bool?,
      types: json['types'] != null
          ? List<dynamic>.from(
              json['types'] as List,
            ).cast<String>()
          : [],
      url: json['url'] as String,
      userRatingsTotal: json['user_ratings_total'] as int,
      utcOffset: json['utc_offset'] as int,
      vicinity: json['vicinity'] as String,
      website: json['website'] as String?,
    );
  }
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

  String toJson() => json.encode(toMap());
}

class CurrentOpeningHours {
  CurrentOpeningHours({
    required this.openNow,
    required this.periods,
    required this.weekdayText,
  });

  factory CurrentOpeningHours.fromJson(Map<String, dynamic> json) {
    return CurrentOpeningHours(
      openNow: json['open_now'] as bool,
      periods: List<dynamic>.from(
        json['periods'] as List,
      ).map((e) => Periods.fromJson(e as Map<String, dynamic>)).toList(),
      weekdayText: List<dynamic>.from(
        json['weekday_text'] as List,
      ).cast<String>(),
    );
  }
  bool openNow;
  List<Periods> periods;
  List<String> weekdayText;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'open_now': openNow,
      'periods': periods.map((x) => x.toMap()).toList(),
      'weekday_text': weekdayText,
    };
  }

  String toJson() => json.encode(toMap());
}

class Photos {
  Photos({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
      height: json['height'] as int,
      htmlAttributions: List<dynamic>.from(
        json['html_attributions'] as List,
      ).cast<String>(),
      photoReference: json['photo_reference'] as String,
      width: json['width'] as int,
    );
  }
  int height;
  List<String> htmlAttributions;
  String photoReference;
  int width;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'height': height,
      'html_attributions': htmlAttributions,
      'photo_reference': photoReference,
      'width': width,
    };
  }

  String toJson() => json.encode(toMap());
}

class Periods {
  Periods({
    required this.close,
    required this.open,
  });

  factory Periods.fromJson(Map<String, dynamic> json) {
    return Periods(
      close: Close.fromJson(json['close'] as Map<String, dynamic>),
      open: Open.fromJson(json['open'] as Map<String, dynamic>),
    );
  }
  Close close;
  Open open;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'close': close.toMap(),
      'open': open.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

class Close {
  Close({
    required this.day,
    required this.time,
    this.date,
    this.truncated,
  });

  factory Close.fromJson(Map<String, dynamic> json) {
    return Close(
      date: json['date'] != null ? json['date'] as String : null,
      day: json['day'] as int,
      time: json['time'] as String,
      truncated: json['truncated'] != null ? json['truncated'] as bool : null,
    );
  }
  String? date;
  int day;
  String time;
  bool? truncated;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'day': day,
      'time': time,
      'truncated': truncated,
    };
  }

  String toJson() => json.encode(toMap());
}

class Open {
  Open({
    required this.date,
    required this.day,
    required this.time,
    this.truncated,
  });

  factory Open.fromJson(Map<String, dynamic> json) {
    return Open(
      date: json['date'] != null ? json['date'] as String : null,
      day: json['day'] as int,
      time: json['time'] as String,
      truncated: json['truncated'] != null ? json['truncated'] as bool : null,
    );
  }
  String? date;
  int day;
  String time;
  bool? truncated;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'day': day,
      'time': time,
      'truncated': truncated,
    };
  }

  String toJson() => json.encode(toMap());
}

class Reviews {
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

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      authorName: json['author_name'] as String?,
      authorUrl: json['author_url'] as String?,
      language: json['language'] as String?,
      originalLanguage: json['original_language'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      rating: json['rating'] as int?,
      relativeTimeDescription: json['relative_time_description'] as String?,
      text: json['text'] as String?,
      time: json['time'] as int?,
      translated: json['translated'] as bool?,
    );
  }
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

  String toJson() => json.encode(toMap());
}
