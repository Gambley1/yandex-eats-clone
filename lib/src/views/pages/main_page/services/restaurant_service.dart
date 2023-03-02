import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart';

final RestaurantApi _restaurantApi = RestaurantApi();

@immutable
class RestaurantService {
  static final RestaurantService _instance =
      RestaurantService._privateConstructor();

  factory RestaurantService() => _instance;

  RestaurantService._privateConstructor();

  RestaurantService get instance => _instance;

  final RestaurantRepository _restaurantRepository =
      RestaurantRepository(api: _restaurantApi);

  Restaurant restaurantById(int id) =>
      instance._restaurantRepository.getRestaurantById(id);
  List<Restaurant> get listRestaurants =>
      instance._restaurantRepository.getListRestaurants();
  List<Restaurant> listRestaurantsByTag({required List<String> categName, required int index}) =>
      instance._restaurantRepository.getRestaurantsByTag(categName, index);
  List<Tag> get listTags => instance._restaurantRepository.getRestaurantsTags();
}
