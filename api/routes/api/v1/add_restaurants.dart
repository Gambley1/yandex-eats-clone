import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';
import 'package:yandex_food_api/src/data/models/fake_restaurant.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response().methodNotAllowed();
  }

  final db = await context.futureRead<Connection>();

  final file = File('data/restaurants.json');
  final restaurantsJsonString = await file.readAsString();
  final restaurantsJson = (jsonDecode(restaurantsJsonString) as List<dynamic>)
      .cast<Map<String, dynamic>>();
  final restaurantInserts = restaurantsJson
      .map(FakeRestaurant.fromJson)
      .map(
        (restaurant) => FakeRestaurantInsert(
          restaurant: DBRestaurantInsertRequest(
            placeId: restaurant.placeId,
            name: restaurant.name,
            latitude: restaurant.latitude,
            longitude: restaurant.longitude,
            businessStatus: restaurant.businessStatus,
            tags: restaurant.tags,
            imageUrl: restaurant.imageUrl,
            rating: restaurant.rating,
            userRatingsTotal: int.tryParse(restaurant.userRatingsTotal) ?? 0,
            openNow: restaurant.openNow,
            popular: restaurant.popular,
          ),
          menuCategories: restaurant.menu.categories
              .map(
                (menuCategory) => DBMenuInsertRequest(
                  category: menuCategory.category,
                  restaurantPlaceId: menuCategory.restaurantPlaceId,
                ),
              )
              .toList(),
          menus: restaurant.menu.items
              .map(
                (menu) => (int id) => menu
                    .map(
                      (item) => DBMenuItemInsertRequest(
                        name: item.name,
                        description: item.description,
                        imageUrl: item.imageUrl,
                        price: item.price,
                        discount: item.discount,
                        menuId: id,
                      ),
                    )
                    .toList(),
              )
              .toList(),
        ),
      )
      .toList();

  await db.dbrestaurants.insertMany([
    for (final insert in restaurantInserts) insert.restaurant,
  ]).whenComplete(() async {
    for (final insert in restaurantInserts) {
      final categoriesId = await db.dbmenus.insertMany(insert.menuCategories);
      for (var i = 0; i < categoriesId.length; i++) {
        final categoryId = categoriesId[i];
        final menus = insert.menus[i](categoryId);
        await Future.wait([
          db.dbmenuItems.insertMany([
            for (final menu in menus) menu,
          ]),
        ]);
      }
    }
  });

  return Response(statusCode: HttpStatus.created);
}
