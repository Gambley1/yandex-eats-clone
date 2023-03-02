import 'package:flutter/foundation.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/views/pages/main_page/services/restaurant_service.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class MainBloc {
  final RestaurantService _restaurantService;

  MainBloc({
    RestaurantService? restaurantService
  }) : _restaurantService = restaurantService ?? RestaurantService();

  final restaurantsSubject = BehaviorSubject<List<Restaurant>>.seeded([]);

  Stream<List<Restaurant>> get streamRestaurant => restaurantsSubject.stream;
  List<Restaurant> get restaurants => restaurantsSubject.value;

  void getRestaurants() {
    final restaurants = _restaurantService.listRestaurants;
    restaurantsSubject.add(restaurants);
  }

  void dispose() {
    restaurantsSubject.close();
  }
}
