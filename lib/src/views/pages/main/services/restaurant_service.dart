import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/repositories/restaurants/restaurants.dart';

@immutable
class RestaurantService extends BaseRestaurantsRepository {
  RestaurantService({RestaurantsRepository? restaurantRepository})
      : _restaurantRepository = restaurantRepository ?? RestaurantsRepository();
  final RestaurantsRepository _restaurantRepository;

  @override
  Future<Restaurant> getRestaurantByPlaceId(
    String placeId, {
    required String latitude,
    required String longitude,
  }) =>
      _restaurantRepository.getRestaurantByPlaceId(
        placeId,
        latitude: latitude,
        longitude: longitude,
      );

  @override
  Future<RestaurantsPage> getRestaurantsPage({
    required double latitude,
    required double longitude,
  }) =>
      _restaurantRepository.getRestaurantsPage(
        latitude: latitude,
        longitude: longitude,
      );
}
