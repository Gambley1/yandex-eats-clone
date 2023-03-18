import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show LocalStorage, RestaurantService, logger;
import 'package:rxdart/rxdart.dart';

@immutable
class MainBloc {
  static final MainBloc _instance = MainBloc._privateConstructor();

  factory MainBloc() => _instance;

  late final RestaurantService _restaurantService;
  late final LocalStorage _localStorage;

  MainBloc._privateConstructor() {
    _restaurantService = RestaurantService();
    _localStorage = LocalStorage.instance;
    // restaurantsPage$.isEmpty ? _fetchFirstPage(null, true) : null;
    logger.w('Fetching for First Page in Singleton');
    _fetchFirstPage(null, true);
  }

  final _restaurantsPageSubject =
      BehaviorSubject<Map<String, dynamic>>.seeded({});

  double get tempLat => _localStorage.tempLatitude;
  double get tempLng => _localStorage.tempLongitude;
  void get removeTempLatAndLng => _localStorage.clearTempLatAndLng();

  // static List<GoogleRestaurant> restaurants = [];
  Map<String, dynamic> get restaurantsPage$ => _restaurantsPageSubject.value;

  Stream<Map<String, dynamic>> get restaurantsPageStream =>
      _restaurantsPageSubject.stream;

  Future<RestaurantsPage> fetchFirstPage(
      String? pageToken, bool forMainPage) async {
    final firstPage =
        await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
    _doSomeFilteringOnPage(firstPage.restaurants);
    // restaurants = firstPage.restaurants;
    // logger.w('GOT SOME RESTAURANTS ${firstPage.restaurants}');
    return firstPage;
  }

  void _fetchFirstPage(String? pageToken, bool forMainPage) async {
    logger.w('Fetching for first page by Page Token $pageToken');
    final firstPage =
        await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
    _doSomeFilteringOnPage(firstPage.restaurants);
    // restaurants = firstPage.restaurants;
    final hasMore = firstPage.nextPageToken == null ? false : true;
    _restaurantsPageSubject.add({
      'restaurants': firstPage.restaurants,
      'page_token': firstPage.nextPageToken,
      'has_more': hasMore,
      'error_message': RestaurantsPage.getErrorMessage(firstPage.errorMessage),
    });
    // logger.w('GOT SOME RESTAURANTS ${firstPage.restaurants}');
  }

  void updateRestaurants(
      double lat, double lng, String? pageToken, bool forMainPage) async {
    logger.w('Updating restaurants with new Lat and Lng by $pageToken');
    final updatedPage = await _restaurantService
        .getRestaurantsPage(pageToken, forMainPage, lat: lat, lng: lng);
    _doSomeFilteringOnPage(updatedPage.restaurants);
    // restaurants = firstPage.restaurants;
    final hasMore = updatedPage.nextPageToken == null ? false : true;
    _restaurantsPageSubject.add({
      'restaurants': updatedPage.restaurants,
      'page_token': updatedPage.nextPageToken,
      'has_more': hasMore,
      'error_message': RestaurantsPage.getErrorMessage(updatedPage.errorMessage),
    });
  }

  Future<RestaurantsPage> getNextRestaurantsPage(
      String? pageToken, bool forMainPage) async {
    logger.w('FETCHING FOR NEXT PAGE by Page Token $pageToken');
    final nextPage =
        await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
    _doSomeFilteringOnPage(nextPage.restaurants);
    // restaurants.addAll(nextPage.restaurants);
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
