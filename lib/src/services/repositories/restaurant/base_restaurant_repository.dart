import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show GoogleRestaurant, Restaurant, Tag;

import '../../../models/restaurant/restaurants_page.dart';

@immutable
abstract class BaseRestaurantRepository {
  // Future<List<Restaurant>> getNearbyRestaurants();
  Future<RestaurantsPage> getRestaurantsPage(String? pageToken, bool mainPage);
  // Future<String> getNextPageToken();
  List<Restaurant> getListRestaurants();
  List<Restaurant> getRestaurantsByTag(List<String> categName, int index);
  List<Tag> getRestaurantsTags();
  Restaurant getRestaurantById(int id);
  GoogleRestaurant getRestaurantByPlaceId(String placeId, List<GoogleRestaurant> restaurants);
}
