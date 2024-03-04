import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/network/api/restaurant_api.dart';
import 'package:papa_burger/src/services/repositories/restaurants/base_restaurants_repository.dart';

@immutable
class RestaurantsRepository implements BaseRestaurantsRepository {
  RestaurantsRepository({
    RestaurantApi? restaurantApi,
  }) : _restaurantApi = restaurantApi ?? RestaurantApi();

  final RestaurantApi _restaurantApi;

  @override
  Future<RestaurantsPage> getRestaurantsPage({
    required double latitude,
    required double longitude,
  }) =>
      _restaurantApi.getRestaurantsPage(
        latitude: '$latitude',
        longitude: '$longitude',
      );

  @override
  Future<Restaurant> getRestaurantByPlaceId(
    String placeId, {
    required String latitude,
    required String longitude,
  }) =>
      _restaurantApi.getRestaurantByPlaceId(
        placeId,
        latitude: latitude,
        longitude: longitude,
      );
}
