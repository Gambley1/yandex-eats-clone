import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart' show Restaurant;

@immutable
abstract class BaseRestaurantRepository {
  Future<RestaurantsPage> getRestaurantsPage(
    String? pageToken, {
    required bool mainPage,
  });
  Restaurant getRestaurantByPlaceId(String placeId);
}
