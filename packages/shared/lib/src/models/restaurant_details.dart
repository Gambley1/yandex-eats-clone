import 'package:shared/shared.dart';

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

  final List<AddressComponents> addressComponents;
  final String adrAddress;
  final String businessStatus;
  final CurrentOpeningHours currentOpeningHours;
  final bool? delivery;
  final bool? dineIn;
  final String formattedAddress;
  final String formattedPhoneNumber;
  final Geometry geometry;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;
  final String internationalPhoneNumber;
  final String name;
  final CurrentOpeningHours openingHours;
  final List<Photos> photos;
  final String placeId;
  final PlusCode plusCode;
  final int? priceLevel;
  final double? rating;
  final String reference;
  final bool? reservable;
  final List<Reviews> reviews;
  final bool? servesBeer;
  final bool? servesBreakfast;
  final bool? servesDinner;
  final bool? servesLunch;
  final bool? servesWine;
  final bool? takeout;
  final List<String> types;
  final String url;
  final int userRatingsTotal;
  final int utcOffset;
  final String vicinity;
  final String? website;
  
  Map<String, dynamic> toJson() => {
        'address_components': addressComponents.map((x) => x.toJson()).toList(),
        'adr_address': adrAddress,
        'business_status': businessStatus,
        'current_opening_hours': currentOpeningHours.toJson(),
        'delivery': delivery,
        'dine_in': dineIn,
        'formatted_address': formattedAddress,
        'formatted_phone_number': formattedPhoneNumber,
        'geometry': geometry.toJson(),
        'icon': icon,
        'icon_background_color': iconBackgroundColor,
        'icon_mask_base_uri': iconMaskBaseUri,
        'international_phone_number': internationalPhoneNumber,
        'name': name,
        'opening_hours': openingHours.toJson(),
        'photos': photos.map((x) => x.toJson()).toList(),
        'place_id': placeId,
        'plus_code': plusCode.toJson(),
        'price_level': priceLevel,
        'rating': rating,
        'reference': reference,
        'reservable': reservable,
        'reviews': reviews.map((x) => x.toJson()).toList(),
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
      weekdayText:
          List<dynamic>.from(json['weekday_text'] as List).cast<String>(),
    );
  }

  final bool openNow;
  final List<Periods> periods;
  final List<String> weekdayText;

  Map<String, dynamic> toJson() => {
        'open_now': openNow,
        'periods': periods.map((x) => x.toJson()).toList(),
        'weekday_text': weekdayText,
      };
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
      htmlAttributions:
          List<dynamic>.from(json['html_attributions'] as List).cast<String>(),
      photoReference: json['photo_reference'] as String,
      width: json['width'] as int,
    );
  }

  final int height;
  final List<String> htmlAttributions;
  final String photoReference;
  final int width;

  Map<String, dynamic> toJson() => {
        'height': height,
        'html_attributions': htmlAttributions,
        'photo_reference': photoReference,
        'width': width,
      };
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

  final Close close;
  final Open open;

  Map<String, dynamic> toJson() => {
        'close': close.toJson(),
        'open': open.toJson(),
      };
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

  final String? date;
  final int day;
  final String time;
  final bool? truncated;

  Map<String, dynamic> toJson() => {
        'date': date,
        'day': day,
        'time': time,
        'truncated': truncated,
      };
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

  final String? date;
  final int day;
  final String time;
  final bool? truncated;

  Map<String, dynamic> toJson() => {
        'date': date,
        'day': day,
        'time': time,
        'truncated': truncated,
      };
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

  final String? authorName;
  final String? authorUrl;
  final String? language;
  final String? originalLanguage;
  final String? profilePhotoUrl;
  final int? rating;
  final String? relativeTimeDescription;
  final String? text;
  final int? time;
  final bool? translated;

  Map<String, dynamic> toJson() => {
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
