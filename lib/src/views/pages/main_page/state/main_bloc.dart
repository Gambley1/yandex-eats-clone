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
    logger.w('Fetching for First Page in Singleton');
    _fetchFirstPage(null, true);
  }

  final _restaurantsPageSubject =
      BehaviorSubject<RestaurantsPage>.seeded(RestaurantsPage(restaurants: []));

  double get tempLat => _localStorage.tempLatitude;
  double get tempLng => _localStorage.tempLongitude;
  bool get hasNewLatAndLng => tempLat != 0 && tempLng != 0;
  void get removeTempLatAndLng => _localStorage.clearTempLatAndLng();

  RestaurantsPage get restaurantsPage$ => _restaurantsPageSubject.value;
  bool get hasMore => restaurantsPage$.hasMore ?? false;

  Stream<RestaurantsPage> get restaurantsPageStream =>
      _restaurantsPageSubject.stream;

  Future<RestaurantsPage> fetchFirstPage(
      String? pageToken, bool forMainPage) async {
    final firstPage =
        await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
    _doSomeFilteringOnPage(firstPage.restaurants);
    return firstPage;
  }

  void _fetchFirstPage(String? pageToken, bool forMainPage) async {
    logger.w('Fetching for first page by Page Token $pageToken');
    final firstPage =
        await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
    _doSomeFilteringOnPage(firstPage.restaurants);
    // restaurants = firstPage.restaurants;
    final hasMore = firstPage.nextPageToken == null ? false : true;
    _restaurantsPageSubject.add(
      RestaurantsPage(
        restaurants: firstPage.restaurants,
        errorMessage: firstPage.errorMessage,
        hasMore: hasMore,
        nextPageToken: firstPage.nextPageToken,
        status: firstPage.status,
      ),
    );
    // logger.w('GOT SOME RESTAURANTS ${firstPage.restaurants}');
  }

  void _fetchAllPages(bool forMainPage) async {
    logger.w('Has more? $hasMore');
    for (var i = 0; hasMore == false; i++) {
      // if (restaurantsPage$['has_more'] == false) return;
      logger.w(
          'Fetching for all pages by Page Token ${restaurantsPage$.nextPageToken}');
      final page = await _restaurantService.getRestaurantsPage(
          restaurantsPage$.nextPageToken, forMainPage);
      _doSomeFilteringOnPage(page.restaurants);
      logger.w('New Page\'s page Token is ${page.nextPageToken}');
      // restaurants = firstPage.restaurants;
      final hasMore = page.nextPageToken == null ? false : true;
      logger.w('New has more? $hasMore');
      if (hasMore == false) return;
      _restaurantsPageSubject.add(RestaurantsPage(
          restaurants: restaurantsPage$.nextPageToken == null
              ? page.restaurants
              : [
                  ...restaurantsPage$.restaurants,
                  ...page.restaurants,
                ],
          errorMessage: page.errorMessage,
          nextPageToken: page.nextPageToken,
          hasMore: hasMore,
          status: page.status));
      logger.w('restaurants page restaurants ${restaurantsPage$.restaurants}');
      logger.w('restaurants page has more ${restaurantsPage$.hasMore}');
      logger.w(
          'new page token of restaurants page is ${restaurantsPage$.nextPageToken}');
    }
  }

  void fetchAllRestaurantsByLocation() async {
    List<GoogleRestaurant> allRestaurants = [];
    String? pageToken;
    do {
      final page = await _restaurantService.getRestaurantsPage(pageToken, true);
      allRestaurants.addAll(page.restaurants);
      pageToken = page.nextPageToken;
    } while (pageToken != null);
    logger.w('all restaurants $allRestaurants');
  }

  void updateRestaurants(
      double lat, double lng, String? pageToken, bool forMainPage) async {
    logger.w('Updating restaurants with new Lat and Lng by $pageToken');
    final updatedPage = await _restaurantService
        .getRestaurantsPage(pageToken, forMainPage, lat: lat, lng: lng);
    _doSomeFilteringOnPage(updatedPage.restaurants);
    // restaurants = firstPage.restaurants;
    final hasMore = updatedPage.nextPageToken == null ? false : true;
    _restaurantsPageSubject.add(
      RestaurantsPage(
        restaurants: updatedPage.restaurants,
        errorMessage: updatedPage.errorMessage,
        hasMore: hasMore,
        nextPageToken: updatedPage.nextPageToken,
        status: updatedPage.status,
      ),
    );
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
