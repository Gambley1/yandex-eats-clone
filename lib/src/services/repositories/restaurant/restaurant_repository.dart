import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show BaseRestaurantRepository, Restaurant, RestaurantApi;

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
  Restaurant getRestaurantByPlaceId(String placeId) {
    final restaurant = _api.getRestaurantByPlaceId(placeId);
    return restaurant;
  }
}
