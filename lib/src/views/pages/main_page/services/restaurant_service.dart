import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart'
    show Restaurant, RestaurantApi, RestaurantRepository, RestaurantsPage;

@immutable
class RestaurantService {
  RestaurantService() {
    _restaurantRepository = RestaurantRepository(api: _restaurantApi);
  }
  late final RestaurantRepository _restaurantRepository;

  final RestaurantApi _restaurantApi = RestaurantApi();

  Restaurant restaurantByPlaceId(String placeId) =>
      _restaurantRepository.getRestaurantByPlaceId(placeId);

  Future<RestaurantsPage> getRestaurantsPage(
    String? pageToken, {
    required bool mainPage,
    double? lat,
    double? lng,
  }) =>
      _restaurantRepository.getRestaurantsPage(
        pageToken,
        mainPage: mainPage,
        lat: lat,
        lng: lng,
      );
}
