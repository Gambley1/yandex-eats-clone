import 'package:dio/dio.dart' show Dio, LogInterceptor;
import 'package:papa_burger/src/restaurant.dart'
    show Restaurant, restaurantsJson, Mapper, logger, Tag;

class RestaurantApi {
  RestaurantApi({
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
    ));
    _dio.options.connectTimeout = 5 * 1000;
    _dio.options.receiveTimeout = 5 * 1000;
    _dio.options.sendTimeout = 5 * 1000;
  }

  final Dio _dio;

  List<Restaurant> getListRestaurants() {
    try {
      final json = restaurantsJson();
      final restaurants = json['restaurants'] as List;
      return restaurants.isNotEmpty
          ? restaurants
              .map<Restaurant>(
                (rest) => Mapper.restaurantFromJson(rest),
              )
              .toList()
          : [];
    } catch (e) {
      logger.e(e.toString(), 'restaurant error');
      return [];
    }
  }

  Restaurant getRestaurantById(int id) {
    try {
      logger.i('getting restaurant by id $id');
      final restaurants = getListRestaurants();
      if (id == 0) return const Restaurant.empty();
      final restaurantById =
          restaurants.firstWhere((restaurant) => restaurant.id == id);
      return restaurantById;
    } catch (e) {
      logger.e(e.toString());
      return const Restaurant.empty();
    }
  }

  List<Tag> getRestaurantsTags() {
    try {
      final restaurants = getListRestaurants();
      final restaurantsTags = restaurants.map((e) => e.tags).toList();

      final restaurantsCateg = restaurantsTags.expand((tag) => tag).toList();

      final Set<Tag> setRestaurantName = Set.from(restaurantsCateg);
      final namesOfCategories = setRestaurantName.toList();
      return namesOfCategories;
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }

  List<Restaurant> getRestaurantsByTag({
    required List<String> categName,
    required int index,
  }) {
    try {
      final restaurants = getListRestaurants();
      final restaurantTags = getRestaurantsTags();
      final filteredRestaurants = restaurants
          .where((restaurant) =>
              restaurantTags.map((tag) => tag.name).contains(categName[index]))
          .toList();
      return filteredRestaurants;
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }
}
