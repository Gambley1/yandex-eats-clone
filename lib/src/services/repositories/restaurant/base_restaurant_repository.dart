import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show GoogleRestaurant, Restaurant;

import '../../../models/restaurant/restaurants_page.dart';

@immutable
abstract class BaseRestaurantRepository {
  Future<RestaurantsPage> getRestaurantsPage(String? pageToken, bool mainPage);
  List<Restaurant> getListRestaurants();
  // List<Restaurant> getRestaurantsByTag(List<String> categName, int index);
  // List<Tag> getRestaurantsTags();
  Restaurant getRestaurantById(int id);
  GoogleRestaurant getRestaurantByPlaceId(String placeId);
}
