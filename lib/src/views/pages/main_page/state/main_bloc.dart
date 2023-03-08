import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/views/pages/main_page/services/restaurant_service.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class MainBloc {
  late final RestaurantService _restaurantService;

  MainBloc() {
    _restaurantService = RestaurantService();
  }

  final restaurantsSubject = BehaviorSubject<List<Restaurant>>.seeded([]);

  Stream<List<Restaurant>> getRestaurants() {
   return restaurantsSubject.distinct().map((restaurants) {
      final restaurants$ = _restaurantService.listRestaurants;
      restaurants = restaurants$;
      return restaurants;
    });
  }

  void dispose() {
    restaurantsSubject.close();
  }
}
