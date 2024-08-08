// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'fake_restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FakeRestaurant _$FakeRestaurantFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FakeRestaurant',
      json,
      ($checkedConvert) {
        final val = FakeRestaurant(
          placeId: $checkedConvert('place_id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          latitude: $checkedConvert('latitude', (v) => (v as num).toDouble()),
          longitude: $checkedConvert('longitude', (v) => (v as num).toDouble()),
          businessStatus:
              $checkedConvert('business_status', (v) => v as String),
          tags: $checkedConvert('tags',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
          rating: $checkedConvert('rating', (v) => (v as num).toDouble()),
          userRatingsTotal:
              $checkedConvert('user_ratings_total', (v) => v as String),
          priceLevel: $checkedConvert('price_level', (v) => (v as num).toInt()),
          openNow: $checkedConvert('open_now', (v) => v as bool),
          popular: $checkedConvert('popular', (v) => v as bool),
          menu: $checkedConvert(
              'menu', (v) => FakeMenu.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'placeId': 'place_id',
        'businessStatus': 'business_status',
        'imageUrl': 'image_url',
        'userRatingsTotal': 'user_ratings_total',
        'priceLevel': 'price_level',
        'openNow': 'open_now'
      },
    );

Map<String, dynamic> _$FakeRestaurantToJson(FakeRestaurant instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'business_status': instance.businessStatus,
      'tags': instance.tags,
      'image_url': instance.imageUrl,
      'rating': instance.rating,
      'user_ratings_total': instance.userRatingsTotal,
      'price_level': instance.priceLevel,
      'open_now': instance.openNow,
      'popular': instance.popular,
      'menu': instance.menu.toJson(),
    };

FakeMenu _$FakeMenuFromJson(Map<String, dynamic> json) => $checkedCreate(
      'FakeMenu',
      json,
      ($checkedConvert) {
        final val = FakeMenu(
          categories: $checkedConvert(
              'categories',
              (v) => const ListFakeMenuCategoriesJsonConverter()
                  .fromJson(v as List)),
          items: $checkedConvert('items',
              (v) => const ListMenuJsonConverter().fromJson(v as List)),
        );
        return val;
      },
    );

Map<String, dynamic> _$FakeMenuToJson(FakeMenu instance) => <String, dynamic>{
      'categories': const ListFakeMenuCategoriesJsonConverter()
          .toJson(instance.categories),
      'items': const ListMenuJsonConverter().toJson(instance.items),
    };

FakeMenuCategory _$FakeMenuCategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FakeMenuCategory',
      json,
      ($checkedConvert) {
        final val = FakeMenuCategory(
          category: $checkedConvert('category', (v) => v as String),
          restaurantPlaceId:
              $checkedConvert('restaurant_place_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'restaurantPlaceId': 'restaurant_place_id'},
    );

Map<String, dynamic> _$FakeMenuCategoryToJson(FakeMenuCategory instance) =>
    <String, dynamic>{
      'category': instance.category,
      'restaurant_place_id': instance.restaurantPlaceId,
    };

FakeMenuItem _$FakeMenuItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FakeMenuItem',
      json,
      ($checkedConvert) {
        final val = FakeMenuItem(
          name: $checkedConvert('name', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
          price: $checkedConvert('price', (v) => (v as num).toDouble()),
          discount: $checkedConvert('discount', (v) => (v as num).toDouble()),
          menuId: $checkedConvert('menu_id', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'imageUrl': 'image_url', 'menuId': 'menu_id'},
    );

Map<String, dynamic> _$FakeMenuItemToJson(FakeMenuItem instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'description': instance.description,
    'image_url': instance.imageUrl,
    'price': instance.price,
    'discount': instance.discount,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('menu_id', instance.menuId);
  return val;
}
