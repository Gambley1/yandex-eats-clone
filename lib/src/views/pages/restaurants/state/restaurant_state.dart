import 'package:papa_burger/src/restaurant.dart';

class RestaurantState {
  RestaurantState({
    this.restaurants = const [],
    this.menus = const [],
  });

  final List<Restaurant> restaurants;
  final List<Menu> menus;

  RestaurantState copyWtih({
    List<Restaurant>? restaurants,
    List<Menu>? menus,
  }) {
    return RestaurantState(
      restaurants: restaurants ?? this.restaurants,
      menus: menus ?? this.menus,
    );
  }
}
