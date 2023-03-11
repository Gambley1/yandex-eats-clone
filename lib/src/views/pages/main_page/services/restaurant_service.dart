import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show Restaurant, RestaurantApi, RestaurantRepository, Tag;

@immutable
class RestaurantService {
  late final RestaurantRepository _restaurantRepository;

  final RestaurantApi _restaurantApi = RestaurantApi();

  RestaurantService() {
    _restaurantRepository = RestaurantRepository(api: _restaurantApi);
  }

  Restaurant restaurantById(int id) =>
      _restaurantRepository.getRestaurantById(id);
  List<Restaurant> get listRestaurants =>
      _restaurantRepository.getListRestaurants();
  List<Restaurant> listRestaurantsByTag(
          {required List<String> categName, required int index}) =>
      _restaurantRepository.getRestaurantsByTag(categName, index);
  List<Tag> get listTags => _restaurantRepository.getRestaurantsTags();
}
