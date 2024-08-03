// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:yandex_food_api/api.dart';

class Restaurant extends Equatable {
  const Restaurant({
    required this.name,
    required this.placeId,
    required this.rating,
    required this.tags,
    required this.imageUrl,
    required this.businessStatus,
    required this.userRatingsTotal,
    required this.openNow,
    required this.location,
    required this.priceLevel,
    this.deliveryTime,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] as String,
      placeId: json['place_id'] as String,
      rating: json['rating'],
      tags: (json['tags'] as List)
          .map((tag) => Tag.fromJson(tag as Map<String, dynamic>))
          .toList(),
      imageUrl: json['image_url'] as String,
      businessStatus: json['business_status'] as String,
      userRatingsTotal: json['user_ratings_total'] as int,
      openNow: json['open_now'] as bool,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      deliveryTime: json['delivery_time'] as int?,
      priceLevel: json['price_level'] as int? ?? 1,
    );
  }

  factory Restaurant.fromView(
    DbrestaurantView restaurant, {
    Location? userLocation,
  }) {
    int? deliveryTime;
    if (userLocation != null) {
      final restaurantLocation = Location(
        lat: restaurant.latitude,
        lng: restaurant.longitude,
      );
      deliveryTime = DeliveryEstimator.estimateDeliveryTime(
        restaurantLocation,
        userLocation,
      ).inMinutes;
      if (deliveryTime <= 5) deliveryTime += 10;
    }
    return Restaurant(
      name: restaurant.name,
      placeId: restaurant.placeId,
      rating: restaurant.rating,
      tags: restaurant.tags.map(Tag.fromName).toList(),
      imageUrl: restaurant.imageUrl,
      businessStatus: restaurant.businessStatus,
      userRatingsTotal: restaurant.userRatingsTotal,
      openNow: restaurant.openNow,
      location: Location(
        lat: restaurant.latitude,
        lng: restaurant.longitude,
      ),
      deliveryTime: deliveryTime,
      // TODO(restaurant): add price level
      priceLevel: Random().nextInt(2) + 1,
    );
  }

  final String name;
  final String placeId;
  final String businessStatus;
  final List<Tag> tags;
  final String imageUrl;
  final dynamic rating;
  final int userRatingsTotal;
  final bool openNow;
  final Location location;
  final int? deliveryTime;
  final int priceLevel;

  String formattedTag(List<String> tags$) => tags$.length == 1
      ? tags$.first.capitalized()
      : '${tags$.first.capitalized()}, ${tags$.last.capitalized()}';

  String formattedDeliveryTime() {
    final deliveryTime = this.deliveryTime ?? 0;
    final canDeliveryByWalk = deliveryTime < 8;
    final time = canDeliveryByWalk ? 15 : deliveryTime;
    return '$time - ${time + 10} min';
  }

  String quality(double rating) {
    var ok = false;
    var good = false;
    var perfect = false;

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

  /// CopyWith Function is used to copy the object itself to modify only
  /// specific field that needed without touching others.
  Restaurant copyWith({
    String? businessStatus,
    int? priceLevel,
    dynamic rating,
    int? userRatingsTotal,
    String? name,
    String? placeId,
    List<Tag>? tags,
    List<Menu>? menu,
    String? imageUrl,
    bool? isFavourite,
    int? deliveryTime,
    Location? location,
    bool? openNow,
  }) {
    return Restaurant(
      location: location ?? this.location,
      openNow: openNow ?? this.openNow,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      businessStatus: businessStatus ?? this.businessStatus,
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
      priceLevel: priceLevel ?? this.priceLevel,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'place_id': placeId,
        'business_status': businessStatus,
        'tags': tags.map((e) => e.toJson()).toList(),
        'image_url': imageUrl,
        'rating': rating,
        'user_ratings_total': userRatingsTotal,
        'open_now': openNow,
        'price_level': priceLevel,
        'location': location.toJson(),
        'delivery_time': deliveryTime,
      };

  @override
  List<Object?> get props => <Object?>[
        name,
        placeId,
        businessStatus,
        tags,
        imageUrl,
        rating,
        userRatingsTotal,
        openNow,
        location,
        priceLevel,
        deliveryTime,
      ];
}

class Tag extends Equatable {
  const Tag({
    required this.name,
    required this.imageUrl,
  });

  factory Tag.fromName(String name) {
    return Tag(
      name: name,
      imageUrl: Tag.getImageUrl(name),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  final String name;
  final String imageUrl;

  @override
  List<Object?> get props => <Object?>[name, imageUrl];

  Map<String, dynamic> toJson() => {
        'name': name,
        'image_url': imageUrl,
      };

  static String getImageUrl(String name) {
    switch (name) {
      case 'Fast Food':
        return 'https://img.freepik.com/premium-vector/fast-food-tasty-set-fast-food-isolated-white_67394-543.jpg';
      case 'Burgers':
        return 'https://img.freepik.com/premium-vector/hand-drawn-big-burger-illustration_266639-146.jpg';
      case 'Pizza':
        return 'https://media.istockphoto.com/id/843213562/vector/cartoon-with-contour-of-pizza-slice-with-melted-cheese-and-pepperoni.jpg?s=612x612&w=0&k=20&c=St6rIJz83w2MjwSPj4EvHA8a4x_z9Rgmsd5TYkvSGH8=';
      case 'Coffee':
        return 'https://images.all-free-download.com/images/graphiclarge/cup_of_coffee_311479.jpg';
      case 'Hot Dogs':
        return 'https://static.vecteezy.com/system/resources/thumbnails/003/345/891/small_2x/delicious-hot-dog-fast-food-icon-free-vector.jpg';
      default:
        return '';
    }
  }
}
