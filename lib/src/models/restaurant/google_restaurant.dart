import 'dart:convert' show json;

import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/data/menus_fake_data_for_restaurants.dart';
import 'package:papa_burger/src/config/extensions/to_upper_case_extension.dart';
import 'package:papa_burger/src/restaurant.dart'
    show Geometry, Item, Menu, Photos, Tag;
import 'package:papa_burger_server/api.dart' as server;

@immutable
class GoogleRestaurant {
  final String businessStatus;
  final Geometry? geometry;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String name;
  final OpeningHours openingHours;
  final List<Photos>? photos;
  final String placeId;
  final PlusCode? plusCode;
  final int? priceLevel;
  final dynamic rating;
  final String? reference;
  final String? scope;
  final List<Tag> tags;
  final int? userRatingsTotal;
  final String? vicinity;
  final bool? permanentlyClosed;
  final List<Menu> menu;
  final String imageUrl;

  const GoogleRestaurant({
    required this.businessStatus,
    required this.name,
    required this.placeId,
    required this.menu,
    required this.tags,
    required this.imageUrl,
    required this.openingHours,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.photos,
    this.plusCode,
    this.priceLevel,
    this.rating,
    this.reference,
    this.scope,
    this.userRatingsTotal,
    this.vicinity,
    this.permanentlyClosed,
  });

  String quality(dynamic rating) {
    bool ok = false;
    bool good = false;
    bool perfect = false;
    if (rating is int) {
      ok = rating >= 2;
      good = rating >= 3;
      perfect = rating >= 4;
    } else {
      ok = rating >= 3;
      good = rating <= 4 && rating >= 3.5;
      perfect = rating >= 4.2;
    }

    if (ok) return 'OK';
    if (good) return 'Good';
    if (perfect) return 'Perfect';
    return '';
  }

  String formattedTag(List<String> tags$) => tags$.length == 1
      ? tags$.first.firstCapitalUpper()
      : '${tags$.first.firstCapitalUpper()}, ${tags$.last.firstCapitalUpper()}';

  const GoogleRestaurant.empty()
      : businessStatus = '',
        geometry = const Geometry.empty(),
        icon = '',
        iconBackgroundColor = '',
        iconMaskBaseUri = '',
        name = '',
        photos = const [],
        placeId = '',
        rating = 0,
        openingHours = const OpeningHours.closed(),
        tags = const [],
        priceLevel = 0,
        plusCode = const PlusCode.empty(),
        reference = '',
        vicinity = '',
        scope = '',
        userRatingsTotal = 0,
        permanentlyClosed = true,
        menu = const [],
        imageUrl = '';

  /// CopyWith Function is used to copy the object itself to modify only
  /// specific field that needed without touching others.
  GoogleRestaurant copyWith({
    String? businessStatus,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    OpeningHours? openingHours,
    List<Photos>? photos,
    PlusCode? plusCode,
    int? priceLevel,
    dynamic rating,
    String? reference,
    String? scope,
    int? userRatingsTotal,
    bool? permanentlyClosed,
    String? vicinity,
    String? placeId,
    List<Tag>? tags,
    List<Menu>? menu,
    String? imageUrl,
  }) {
    return GoogleRestaurant(
      businessStatus: businessStatus ?? this.businessStatus,
      geometry: geometry ?? this.geometry,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconMaskBaseUri: iconMaskBaseUri ?? this.iconMaskBaseUri,
      name: name ?? this.name,
      openingHours: openingHours ?? this.openingHours,
      photos: photos ?? this.photos,
      placeId: placeId ?? this.placeId,
      plusCode: plusCode ?? this.plusCode,
      priceLevel: priceLevel ?? this.priceLevel,
      rating: rating ?? this.rating,
      reference: reference ?? this.reference,
      scope: scope ?? this.scope,
      tags: tags ?? this.tags,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      permanentlyClosed: permanentlyClosed ?? this.permanentlyClosed,
      vicinity: vicinity ?? this.vicinity,
      menu: menu ?? this.menu,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'business_status': businessStatus,
      'geometry': geometry?.toMap(),
      'icon': icon,
      'icon_background_color': iconBackgroundColor,
      'icon_mask_base_uri': iconMaskBaseUri,
      'name': name,
      'opening_hours': openingHours.toMap(),
      'photos': photos?.map((x) => x.toMap()).toList(),
      'place_id': placeId,
      'plus_code': plusCode?.toMap(),
      'price_level': priceLevel,
      'rating': rating,
      'reference': reference,
      'scope': scope,
      'tags': tags,
      'user_ratings_total': userRatingsTotal,
      'vicinity': vicinity,
      'permanently_closed': permanentlyClosed,
      'image_url': imageUrl,
    };
  }

  factory GoogleRestaurant.fromJson(Map<String, dynamic> json) {
    imageUrl(Map<String, dynamic> json) {
      final isNotEmpty =
          json['photos'] != null || List.from(json['photos'] ?? []).isNotEmpty;
      if (isNotEmpty) {
        final photoReference = json['photos'][0]['photo_reference'];
        final photoWidth = json['photos'][0]['width'];
        return 'https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyCpduAH-GFwI1zzv3RCwvvveyDP7JsSink&photoreference=$photoReference&maxwidth=$photoWidth';
      } else {
        return 'https://static.heyyou.io/images/vendor/cover/default_vendor_cover-640x300.jpg';
      }
    }

    return GoogleRestaurant(
      businessStatus: json['business_status'] as String,
      geometry: Geometry.fromJson(json['geometry']),
      icon: json['icon'] as String,
      iconBackgroundColor: json['icon_background_color'] as String,
      iconMaskBaseUri: json['icon_mask_base_uri'] as String,
      name: json['name'] as String,
      openingHours: OpeningHours.fromJson(json['opening_hours'] ?? {}),
      photos: json['photos'] != null
          ? List<Photos>.from(
              (json['photos']).map<Photos>(
                (json) => Photos.fromJson(json),
              ),
            )
          : [],
      placeId: json['place_id'] as String,
      plusCode: PlusCode.fromJson(json['plus_code'] ?? {}),
      priceLevel: json['price_level'],
      rating: json['rating'] ?? 0,
      reference: json['reference'] as String,
      scope: json['scope'] as String,
      tags: List<Tag>.from(
        (json['tags']),
      ),
      permanentlyClosed: json['permanently_closed'],
      userRatingsTotal: json['user_ratings_total'],
      vicinity: json['vicinity'] as String,
      menu: FakeMenus(numOfRatings: json['user_ratings_total'] ?? 1)
          .getRandomMenu(),
      imageUrl: json['image_url'] ?? imageUrl(json),
    );
  }

  factory GoogleRestaurant.fromDb(server.Restaurant rest) {
    return GoogleRestaurant(
      businessStatus: rest.businessStatus,
      name: rest.name,
      placeId: rest.placeId,
      tags: List<Tag>.from(
        (rest.tags).map(
          (e) => Tag(name: e, imageUrl: ''),
        ),
      ),
      imageUrl: rest.imageUrl,
      rating: rest.rating,
      userRatingsTotal: rest.userRatingsTotal,
      openingHours: OpeningHours(openNow: rest.openNow),
      menu: rest.menu!
          .map((menu) => Menu(
              category: menu.category,
              items: menu.items
                  .map<Item>((item) => Item(
                      name: item.name,
                      description: item.description,
                      imageUrl: item.imageUrl,
                      price: item.price,
                      discount: item.discount))
                  .toList()))
          .toList(),
    );
  }

  factory GoogleRestaurant.fromBackend(server.Restaurant rest) {
    return GoogleRestaurant(
      businessStatus: rest.businessStatus,
      name: rest.name,
      placeId: rest.placeId,
      tags: List<Tag>.from(
        (rest.tags).map(
          (e) => Tag.fromJson(e),
        ),
      ),
      imageUrl: rest.imageUrl,
      rating: rest.rating,
      userRatingsTotal: rest.userRatingsTotal,
      openingHours: OpeningHours(openNow: rest.openNow),
      menu: rest.menu!
          .map((menu) => Menu(
              category: menu.category,
              items: menu.items
                  .map<Item>((item) => Item(
                      name: item.name,
                      description: item.description,
                      imageUrl: item.imageUrl,
                      price: item.price,
                      discount: item.discount))
                  .toList()))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());
}

@immutable
class OpeningHours {
  final bool openNow;

  const OpeningHours({required this.openNow});

  const OpeningHours.closed() : openNow = false;

  const OpeningHours.opened() : openNow = true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'open_now': openNow,
    };
  }

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      openNow: json['open_now'] as bool,
    );
  }

  String toJson() => json.encode(toMap());
}

@immutable
class PlusCode {
  final String compoundCode;
  final String globalCode;

  const PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  const PlusCode.empty()
      : compoundCode = '',
        globalCode = '';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'compound_code': compoundCode,
      'global_code': globalCode,
    };
  }

  factory PlusCode.fromJson(Map<String, dynamic> json) {
    return PlusCode(
      compoundCode: json['compound_code'] ?? '',
      globalCode: json['global_code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
}
