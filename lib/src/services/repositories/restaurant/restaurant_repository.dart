import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show BaseRestaurantRepository, Restaurant, RestaurantApi;

@immutable
class RestaurantRepository implements BaseRestaurantRepository {
  RestaurantRepository({
    RestaurantApi? restaurantApi,
  }) : _restaurantApi = restaurantApi ?? RestaurantApi();

  final RestaurantApi _restaurantApi;

  @override
  Future<RestaurantsPage> getRestaurantsPage({
    required double latitude,
    required double longitude,
  }) async =>
      _restaurantApi.getRestaurantsPage(
        latitude: '$latitude',
        longitude: '$longitude',
      );

  @override
  Future<Restaurant> getRestaurantByPlaceId(
    String placeId, {
    required String latitude,
    required String longitude,
  }) async =>
      _restaurantApi.getRestaurantByPlaceId(
        placeId,
        latitude: latitude,
        longitude: longitude,
      );
}
