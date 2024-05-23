import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger_server/api.dart' as api;
import 'package:shared/shared.dart';

class RestaurantApi {
  RestaurantApi({api.ApiClient? apiClient})
      : _apiClient = apiClient ?? api.ApiClient();
  final api.ApiClient _apiClient;

  Future<RestaurantsPage> getRestaurantsPage({
    required String latitude,
    required String longitude,
  }) async {
    try {
      final restaurants$ = await _apiClient
          .getAllRestaurants(
            latitude: latitude,
            longitude: longitude,
          )
          .timeout(defaultTimeout);
      final restaurants = restaurants$.map(Restaurant.fromDb).toList();
      return RestaurantsPage(restaurants: restaurants);
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  Future<List<Restaurant>> getPopularRestaurants({
    required String latitude,
    required String longitude,
  }) async {
    try {
      final restaurant = await _apiClient
          .getPopularRestaurants(
            latitude: latitude,
            longitude: longitude,
          )
          .timeout(defaultTimeout);
      return restaurant.map(Restaurant.fromDb).toList();
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  Future<Restaurant> getRestaurantByPlaceId(
    String placeId, {
    required String latitude,
    required String longitude,
  }) async {
    if (placeId.isEmpty) return const Restaurant.empty();
    try {
      final restaurant = await _apiClient
          .getRestaurantByPlaceId(
            placeId,
            latitude: latitude,
            longitude: longitude,
          )
          .timeout(defaultTimeout);
      return Restaurant.fromDb(restaurant);
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  Future<List<Tag>> getRestaurantsTags({
    required String latitude,
    required String longitude,
  }) async {
    try {
      final tags = await _apiClient
          .getRestaurantsTags(
            latitude: latitude,
            longitude: longitude,
          )
          .timeout(defaultTimeout);
      return tags
          .map(
            (tag) => Tag(
              name: tag.name,
              imageUrl: tag.imageUrl,
            ),
          )
          .toList();
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  Future<List<Restaurant>> getRestaurantsByTags({
    required List<String> tags,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final restaurants = await _apiClient
          .getRestaurantsByTags(
            tags,
            latitude: latitude,
            longitude: longitude,
          )
          .timeout(defaultTimeout);
      return restaurants.map(Restaurant.fromDb).toList();
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }
}
