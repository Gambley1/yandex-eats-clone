import 'package:yandex_food_api/api.dart';

/// Restaurants page model
class RestaurantsPage {
  /// {@macro restaurants_page}
  const RestaurantsPage({
    required this.restaurants,
    required this.tags,
  });

  /// Restaurants page list restaurants
  final List<Restaurant> restaurants;

  /// Restaurants page list restaurants' tags
  final List<Tag> tags;
}
