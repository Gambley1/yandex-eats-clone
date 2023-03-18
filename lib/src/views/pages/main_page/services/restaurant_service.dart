import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show GoogleRestaurant, Restaurant, RestaurantApi, RestaurantRepository, Tag;

@immutable
class RestaurantService {
  late final RestaurantRepository _restaurantRepository;

  final RestaurantApi _restaurantApi = RestaurantApi();

  RestaurantService() {
    _restaurantRepository = RestaurantRepository(api: _restaurantApi);
  }

  Restaurant restaurantById(int id) =>
      _restaurantRepository.getRestaurantById(id);
  GoogleRestaurant restaurantByPlaceId(
          String placeId, List<GoogleRestaurant> restaurants) =>
      _restaurantRepository.getRestaurantByPlaceId(placeId, restaurants);

  Future<RestaurantsPage> getRestaurantsPage(
          String? pageToken, bool mainPage, {double? lat, double? lng}) =>
      _restaurantRepository.getRestaurantsPage(pageToken, mainPage, lat: lat, lng: lng);

  // Future<String> get getNextPageToken =>
  //     _restaurantRepository.getNextPageToken();

  // Future<List<Restaurant>> get nearbyRestaurants =>
  //     _restaurantRepository.getNearbyRestaurants();

  List<Restaurant> get listRestaurants =>
      _restaurantRepository.getListRestaurants();
  List<Restaurant> listRestaurantsByTag(
          {required List<String> categName, required int index}) =>
      _restaurantRepository.getRestaurantsByTag(categName, index);

  List<Tag> get listTags => _restaurantRepository.getRestaurantsTags();
}
