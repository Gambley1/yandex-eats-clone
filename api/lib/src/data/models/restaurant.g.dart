// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Restaurant',
      json,
      ($checkedConvert) {
        final val = Restaurant(
          name: $checkedConvert('name', (v) => v as String),
          placeId: $checkedConvert('place_id', (v) => v as String),
          rating: $checkedConvert('rating', (v) => v),
          tags: $checkedConvert(
              'tags',
              (v) => (v as List<dynamic>)
                  .map((e) => Tag.fromJson(e as Map<String, dynamic>))
                  .toList()),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
          businessStatus:
              $checkedConvert('business_status', (v) => v as String),
          userRatingsTotal:
              $checkedConvert('user_ratings_total', (v) => (v as num).toInt()),
          openNow: $checkedConvert('open_now', (v) => v as bool),
          location: $checkedConvert(
              'location', (v) => Location.fromJson(v as Map<String, dynamic>)),
          priceLevel: $checkedConvert('price_level', (v) => (v as num).toInt()),
          deliveryTime:
              $checkedConvert('delivery_time', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'placeId': 'place_id',
        'imageUrl': 'image_url',
        'businessStatus': 'business_status',
        'userRatingsTotal': 'user_ratings_total',
        'openNow': 'open_now',
        'priceLevel': 'price_level',
        'deliveryTime': 'delivery_time'
      },
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'place_id': instance.placeId,
    'business_status': instance.businessStatus,
    'tags': instance.tags.map((e) => e.toJson()).toList(),
    'image_url': instance.imageUrl,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('rating', instance.rating);
  val['user_ratings_total'] = instance.userRatingsTotal;
  val['open_now'] = instance.openNow;
  val['location'] = instance.location.toJson();
  val['delivery_time'] = instance.deliveryTime;
  val['price_level'] = instance.priceLevel;
  return val;
}

Tag _$TagFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Tag',
      json,
      ($checkedConvert) {
        final val = Tag(
          name: $checkedConvert('name', (v) => v as String),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'imageUrl': 'image_url'},
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'name': instance.name,
      'image_url': instance.imageUrl,
    };
