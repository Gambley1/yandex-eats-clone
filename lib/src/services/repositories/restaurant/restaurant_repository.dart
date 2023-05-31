import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show BaseRestaurantRepository, GoogleRestaurant, Restaurant, RestaurantApi;

@immutable
class RestaurantRepository implements BaseRestaurantRepository {
  RestaurantRepository({
    RestaurantApi? api,
  }) : _api = api ?? RestaurantApi();

  final RestaurantApi _api;

  @override
  Future<RestaurantsPage> getRestaurantsPage(
    String? pageToken, {
    required bool mainPage,
    double? lat,
    double? lng,
  }) async {
    final page = await _api.getRestaurantsPage(
      pageToken,
      mainPage: mainPage,
      lat$: lat,
      lng$: lng,
    );
    return page;
  }

  @override
  List<Restaurant> getListRestaurants() {
    final restaurants = _api.getListRestaurants();
    return restaurants;
  }

  @override
  Restaurant getRestaurantById(int id) {
    final restaurant = _api.getRestaurantById(id);
    return restaurant;
  }

  @override
  GoogleRestaurant getRestaurantByPlaceId(String placeId) {
    final restaurant = _api.getRestaurantByPlaceId(placeId);
    return restaurant;
  }

  // @override
  // List<Restaurant> getRestaurantsByTag(List<String> categName, int index) {
  //   final restaurants =
  //       _api.getRestaurantsByTag(categName: categName, index: index);
  //   return restaurants;
  // }

  // @override
  // List<Tag> getRestaurantsTags() {
  //   final tags = _api.getRestaurantsTags();
  //   return tags;
  // }
}
