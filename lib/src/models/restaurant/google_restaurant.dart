import 'dart:convert' show json;

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show StringCharacters;
import 'package:papa_burger/src/data/menus_fake_data_for_restaurants.dart';
import 'package:papa_burger/src/models/restaurant/google_restaurant_details.dart';
import 'package:papa_burger/src/restaurant.dart'
    show Geometry, Menu, Photos, RestaurantApi;

@immutable
class GoogleRestaurant {
  final String businessStatus;
  final Geometry geometry;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String name;
  final OpeningHours? openingHours;
  final List<Photos> photos;
  final String placeId;
  final PlusCode? plusCode;
  final int? priceLevel;
  final dynamic rating;
  final String? reference;
  final String? scope;
  final List<String> types;
  final int? userRatingsTotal;
  final String? vicinity;
  final bool? permanentlyClosed;
  final List<Menu> menu;

  const GoogleRestaurant({
    required this.businessStatus,
    required this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    required this.name,
    this.openingHours,
    required this.photos,
    required this.placeId,
    this.plusCode,
    this.priceLevel,
    required this.rating,
    this.reference,
    this.scope,
    required this.types,
    this.userRatingsTotal,
    required this.vicinity,
    this.permanentlyClosed,
    required this.menu,
  });

  String imageUrl(String photoReference, int width) =>
      RestaurantApi().getImageUrlsByPhotoReference(photoReference, width);

  Future<GoogleRestaurantDetails> get getDetails =>
      RestaurantApi().getRestaurantDetails(placeId);

  String formattedTag(String tag) =>
      ', ${tag.characters.first.toUpperCase()}${tag.replaceFirst(tag.characters.first, '')}';

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
        types = const [],
        priceLevel = 0,
        plusCode = const PlusCode.empty(),
        reference = '',
        vicinity = '',
        scope = '',
        userRatingsTotal = 0,
        permanentlyClosed = true,
        menu = const [];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'business_status': businessStatus,
      'geometry': geometry.toMap(),
      'icon': icon,
      'icon_background_color': iconBackgroundColor,
      'icon_mask_base_uri': iconMaskBaseUri,
      'name': name,
      'opening_hours': openingHours?.toMap(),
      'photos': photos.map((x) => x.toMap()).toList(),
      'place_id': placeId,
      'plus_code': plusCode?.toMap(),
      'price_level': priceLevel,
      'rating': rating,
      'reference': reference,
      'scope': scope,
      'types': types,
      'user_ratings_total': userRatingsTotal,
      'vicinity': vicinity,
      'permanently_closed': permanentlyClosed,
    };
  }

  factory GoogleRestaurant.fromJson(Map<String, dynamic> json) {
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
      types: List<String>.from(
        (json['types']),
      ),
      permanentlyClosed: json['permanently_closed'],
      userRatingsTotal: json['user_ratings_total'],
      vicinity: json['vicinity'] as String,
      menu: FakeMenus(numOfRatings: json['user_ratings_total']).getRandomMenu(),
    );
  }

  String toJson() => json.encode(toMap());
}

@immutable
class OpeningHours {
  final bool openNow;

  const OpeningHours({required this.openNow});

  const OpeningHours.closed() : openNow = false;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'open_now': openNow,
    };
  }

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      openNow: json['open_now'] ?? false,
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
