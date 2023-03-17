import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart' show RestaurantService, logger;

@immutable
class MainBloc {
  late final RestaurantService _restaurantService;

  MainBloc() {
    _restaurantService = RestaurantService();
  }

  static List<GoogleRestaurant> restaurants = [];

  Future<RestaurantsPage> fetchFirstPage(
      String? pageToken, bool forMainPage) async {
    final firstPage =
        await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
    _doSomeFilteringOnPage(firstPage.restaurants);
    restaurants = firstPage.restaurants;
    logger.w('GOT SOME RESTAURANTS ${firstPage.restaurants}');
    return firstPage;
  }

  Future<RestaurantsPage> getNextRestaurantsPage(
      String? pageToken, bool forMainPage) async {
    logger.w('FETCHING FOR NEXT PAGE by Page Token $pageToken');
    final nextPage =
        await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
    _doSomeFilteringOnPage(nextPage.restaurants);
    restaurants.addAll(nextPage.restaurants);
    return nextPage;
  }

  void _doSomeFilteringOnPage(
    List<GoogleRestaurant> restaurants,
  ) {
    // Removing if permanently closed
    restaurants.removeWhere((restaurant) => restaurant.name == 'Ne Rabotayet');
    restaurants
        .removeWhere((restaurant) => restaurant.permanentlyClosed == true);
  }
}
