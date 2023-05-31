import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show GoogleRestaurant, Restaurant;

@immutable
abstract class BaseRestaurantRepository {
  Future<RestaurantsPage> getRestaurantsPage(
    String? pageToken, {
    required bool mainPage,
  });
  List<Restaurant> getListRestaurants();
  // List<Restaurant> getRestaurantsByTag(List<String> categName, int index);
  // List<Tag> getRestaurantsTags();
  Restaurant getRestaurantById(int id);
  GoogleRestaurant getRestaurantByPlaceId(String placeId);
}
