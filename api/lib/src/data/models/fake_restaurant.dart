import 'package:json_annotation/json_annotation.dart';
import 'package:yandex_food_api/api.dart';

part 'fake_restaurant.g.dart';

class ListFakeMenuCategoriesJsonConverter
    extends JsonConverter<List<FakeMenuCategory>, List<dynamic>> {
  const ListFakeMenuCategoriesJsonConverter();

  @override
  List<FakeMenuCategory> fromJson(List<dynamic> json) {
    return json
        .cast<Map<String, dynamic>>()
        .map(FakeMenuCategory.fromJson)
        .toList();
  }

  @override
  List<dynamic> toJson(List<FakeMenuCategory> object) {
    return object.map((e) => e.toJson()).toList();
  }
}

class ListMenuJsonConverter
    extends JsonConverter<List<List<FakeMenuItem>>, List<dynamic>> {
  const ListMenuJsonConverter();

  @override
  List<List<FakeMenuItem>> fromJson(List<dynamic> json) {
    return json
        .cast<List<dynamic>>()
        .map(
          (e) => e
              .cast<Map<String, dynamic>>()
              .map(FakeMenuItem.fromJson)
              .toList(),
        )
        .toList();
  }

  @override
  List<dynamic> toJson(List<List<FakeMenuItem>> object) {
    return object.map((e) => e.map((item) => item.toJson()).toList()).toList();
  }
}

class FakeRestaurantInsert {
  FakeRestaurantInsert({
    required this.restaurant,
    required this.menuCategories,
    required this.menus,
  });

  final DBRestaurantInsertRequest restaurant;
  final List<DBMenuInsertRequest> menuCategories;
  final List<List<DBMenuItemInsertRequest> Function(int id)> menus;
}

@JsonSerializable()
class FakeRestaurant {
  const FakeRestaurant({
    required this.placeId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.businessStatus,
    required this.tags,
    required this.imageUrl,
    required this.rating,
    required this.userRatingsTotal,
    required this.priceLevel,
    required this.openNow,
    required this.popular,
    required this.menu,
  });

  factory FakeRestaurant.fromJson(Map<String, dynamic> json) =>
      _$FakeRestaurantFromJson(json);

  final String placeId;
  final String name;
  final double latitude;
  final double longitude;
  final String businessStatus;
  final List<String> tags;
  final String imageUrl;
  final double rating;
  final String userRatingsTotal;
  final int priceLevel;
  final bool openNow;
  final bool popular;
  final FakeMenu menu;

  Map<String, dynamic> toJson() => _$FakeRestaurantToJson(this);
}

@JsonSerializable()
class FakeMenu {
  const FakeMenu({required this.categories, required this.items});

  factory FakeMenu.fromJson(Map<String, dynamic> json) =>
      _$FakeMenuFromJson(json);

  @ListFakeMenuCategoriesJsonConverter()
  final List<FakeMenuCategory> categories;
  @ListMenuJsonConverter()
  final List<List<FakeMenuItem>> items;

  Map<String, dynamic> toJson() => _$FakeMenuToJson(this);
}

@JsonSerializable()
class FakeMenuCategory {
  FakeMenuCategory({required this.category, required this.restaurantPlaceId});

  factory FakeMenuCategory.fromJson(Map<String, dynamic> json) =>
      _$FakeMenuCategoryFromJson(json);

  final String category;
  final String restaurantPlaceId;

  Map<String, dynamic> toJson() => _$FakeMenuCategoryToJson(this);
}

@JsonSerializable()
class FakeMenuItem {
  const FakeMenuItem({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discount,
    this.menuId,
  });

  factory FakeMenuItem.fromJson(Map<String, dynamic> json) =>
      _$FakeMenuItemFromJson(json);

  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double discount;
  final String? menuId;

  Map<String, dynamic> toJson() => _$FakeMenuItemToJson(this);

  FakeMenuItem copyWith({
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    double? discount,
    String? menuId,
  }) {
    return FakeMenuItem(
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      menuId: menuId ?? this.menuId,
    );
  }
}
