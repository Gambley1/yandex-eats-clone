import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show BaseRestaurantRepository, GoogleRestaurant, Restaurant, RestaurantApi, Tag;

@immutable
class RestaurantRepository implements BaseRestaurantRepository {
  const RestaurantRepository({
    required this.api,
  });

  final RestaurantApi api;

  // @override
  // Future<List<Restaurant>> getNearbyRestaurants() async {
  //   final restaurants =
  //       await api.getNearbyRestaurantsByLocation();
  //   return restaurants;
  // }

  @override
  Future<RestaurantsPage> getRestaurantsPage(String? pageToken, bool mainPage) async {
    final page = await api.getRestaurantsPage(pageToken, mainPage);
    return page;
  }

  // @override
  // Future<String> getNextPageToken() async {
  //   final nextPageToken = await api.getNextPageToken();
  //   return nextPageToken;
  // }

  @override
  List<Restaurant> getListRestaurants() {
    final restaurants = api.getListRestaurants();
    return restaurants;
  }

  @override
  Restaurant getRestaurantById(int id) {
    final restaurant = api.getRestaurantById(id);
    return restaurant;
  }

  @override
  GoogleRestaurant getRestaurantByPlaceId(String placeId, List<GoogleRestaurant> restaurants) {
    final restaurant = api.getRestaurantByPlaceId(placeId, restaurants);
    return restaurant;
  }

  @override
  List<Restaurant> getRestaurantsByTag(List<String> categName, int index) {
    final restaurants =
        api.getRestaurantsByTag(categName: categName, index: index);
    return restaurants;
  }

  @override
  List<Tag> getRestaurantsTags() {
    final tags = api.getRestaurantsTags();
    return tags;
  }
}
