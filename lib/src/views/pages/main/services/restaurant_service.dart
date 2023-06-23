import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart'
    show
        BaseRestaurantRepository,
        Restaurant,
        RestaurantRepository,
        RestaurantsPage;

@immutable
class RestaurantService extends BaseRestaurantRepository {
  RestaurantService({RestaurantRepository? restaurantRepository})
      : _restaurantRepository = restaurantRepository ?? RestaurantRepository();
  final RestaurantRepository _restaurantRepository;

  @override
  Future<Restaurant> getRestaurantByPlaceId(
    String placeId, {
    required String latitude,
    required String longitude,
  }) async =>
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
