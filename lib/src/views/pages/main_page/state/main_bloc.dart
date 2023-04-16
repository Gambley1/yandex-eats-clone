import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show LocalStorage, RestaurantApi, RestaurantService, logger;
import 'package:rxdart/rxdart.dart';

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
    // fetchAllRestaurantsByLocation();
  }

  final _restaurantsPageSubject =
      BehaviorSubject<RestaurantsPage>.seeded(RestaurantsPage(restaurants: []));

  double get tempLat => _localStorage.tempLatitude;
  double get tempLng => _localStorage.tempLongitude;
  bool get hasNewLatLng => tempLat != 0 && tempLng != 0;
  void get removeTempLatLng => _localStorage.clearTempLatLng();

  RestaurantsPage get restaurantsPage$ => _restaurantsPageSubject.value;
  bool get hasMore => restaurantsPage$.hasMore ?? false;

  Stream<RestaurantsPage> get restaurantsPageStream =>
      _restaurantsPageSubject.stream;

  List<GoogleRestaurant> allRestaurants = [];
  String? pageToken;

  List<GoogleRestaurant> get popularRestaurants =>
      allRestaurants.where((rest) => rest.rating > 400).toList();

  Future<List> getFakeRestaurants() async {
    return await RestaurantApi().testBackendCall();
  }

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

  void fetchAllRestaurantsByLocation(
      {bool updateByNewLatLng = false, double? lat, double? lng}) async {
    if (updateByNewLatLng && lat != null && lng != null) {
      /// Clearing all and then fetching again for new restaurants with new lat and lng.
      // allRestaurants.clear();
      _getAllRestaurants(lat: lat, lng: lng);
    } else {
      _getAllRestaurants();
    }
  }

  _getAllRestaurants({double? lat, double? lng}) async {
    final page = await _restaurantService.getRestaurantsPage(
      pageToken,
      true,
      lat: lat,
      lng: lng,
    );
    allRestaurants.addAll(page.restaurants);
    _doSomeFilteringOnPage(allRestaurants);
    pageToken = page.nextPageToken;
    final hasMore = page.nextPageToken == null ? false : true;
    logger.w(
        'All restaurants $allRestaurants and length is ${allRestaurants.length}');
    await Future.delayed(const Duration(milliseconds: 1800));
    if (hasMore) {
      logger.w('Fetching for one more time');
      fetchAllRestaurantsByLocation();
    } else {
      _restaurantsPageSubject.add(
        RestaurantsPage(
          restaurants: allRestaurants,
          hasMore: false,
        ),
      );
    }
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

    restaurants.removeDuplicates(
      by: (item) => item.name,
    );
    restaurants.whereMoveToTheFront(
      (item) => item.rating >= 4.3 && item.userRatingsTotal! >= 1000,
    );
    restaurants.whereMoveToTheEnd((item) =>
        item.rating == null ||
        item.rating <= 3 ||
        item.userRatingsTotal == null);
  }
}
