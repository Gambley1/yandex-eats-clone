// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:isolate';

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show FicListExtension;
import 'package:papa_burger/src/models/exceptions.dart';
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        ClientTimeoutException,
        LocalStorage,
        RestaurantApi,
        RestaurantService,
        Tag,
        logger;
import 'package:papa_burger/src/views/pages/main_page/state/main_page_state.dart';
import 'package:rxdart/rxdart.dart'
    show
        BehaviorSubject,
        OnErrorExtensions,
        Rx,
        StartWithExtension,
        SwitchMapExtension;

class MainBloc {
  factory MainBloc() => _instance;

  MainBloc._privateConstructor() {
    _restaurantService = RestaurantService();
    _localStorage = LocalStorage.instance;
    // _fetchFirstPage(null, true);
    fetchAllRestaurantsByLocation();
    // RestaurantApi().getRestaurantsPageFromAppwriteClient();
  }
  static final MainBloc _instance = MainBloc._privateConstructor();

  late final RestaurantService _restaurantService;
  late final LocalStorage _localStorage;

  final _restaurantsPageSubject =
      BehaviorSubject<RestaurantsPage>.seeded(RestaurantsPage(restaurants: []));
  // final _refreshSubect = BehaviorSubject<Completer<void>>();
  // final _filterRestaurantsByTagSubject = BehaviorSubject<String>.seeded('');

  double get tempLat => _localStorage.tempLatitude;
  double get tempLng => _localStorage.tempLongitude;
  bool get hasNewLatLng => tempLat != 0 && tempLng != 0;
  void get removeTempLatLng => _localStorage.clearTempLatLng();
  void get clearAllRestaurants {
    popularRestaurants.clear();
    filteredRestaurantsByTag.clear();
    restaurantsTags.clear();
    logger.w('Popular restaurants $popularRestaurants');
  }

  RestaurantsPage get restaurantsPage$ => _restaurantsPageSubject.value;
  bool get hasMore => restaurantsPage$.hasMore ?? false;

  Stream<RestaurantsPage> get restaurantsPageStream =>
      _restaurantsPageSubject.stream.distinct();

  List<GoogleRestaurant> allRestaurants = [];
  List<GoogleRestaurant> popularRestaurants = [];
  List<GoogleRestaurant> filteredRestaurantsByTag = [];
  List<Tag> restaurantsTags = [];
  String? pageToken;

  Future<void> refresh() async {
    if (popularRestaurants.isNotEmpty && restaurantsTags.isNotEmpty) {
      _restaurantsPageSubject.add(
        RestaurantsPage(restaurants: []),
      );
    } else {
      _restaurantsPageSubject.add(
        RestaurantsPage(restaurants: []),
      );
      await _getPopularRestaurants;
      await _getRestaurantsTags;
    }
  }

  /// Stream to maintain all possible states of main page throught restaurants page
  /// from backend.
  ///
  /// Before it goes to the computing the method where we get our restaurants, we
  /// check whether _restaurantsPageSubject value(page) is empty, if it is not empty
  /// returning already extsiting restaurants in order to avoid unnesecary Backend
  /// API call.
  ///
  /// Gets Restaurants page from Backend and return appropriate state depening on
  /// the result from [getRestaurantsPageFromBackend()] method. Whether it's empty
  /// returning MainPageStateWithNoRestaurants. If it has error returning MainPageError
  /// and if it has restaurants returning MainPageWithRestauraurants.
  Stream<MainPageState> get mainPageState {
    return _restaurantsPageSubject.distinct().switchMap(
      (page) {
        if (page.restaurants.isEmpty) {
          final lat = _localStorage.latitude.toString();
          final lng = _localStorage.longitude.toString();
          return Rx.fromCallable(
            () => RestaurantApi()
                .getDBRestaurantsPageFromBackend(
                  latitude: lat,
                  longitude: lng,
                )
                .timeout(const Duration(seconds: 5)),
          ).map(
            (newPage) {
              if (newPage.restaurants.isEmpty) {
                return const MainPageWithNoRestaurants();
              }
              _filterPage(newPage);
              page.restaurants.clear();
              page.restaurants.addAll(newPage.restaurants);
              // allRestaurants.addAll(newPage.restaurants);
              return MainPageWithRestaurants(restaurants: newPage.restaurants);
            },
          ).onErrorReturnWith(
            (error, stackTrace) {
              logger
                ..e(stackTrace)
                ..e(error);
              return MainPageError(error: error);
            },
          ).startWith(const MainPageLoading());
        } else {
          logger.w('Returning already exsisting Restaurants from stream.');
          return Stream<MainPageWithRestaurants>.value(
            MainPageWithRestaurants(restaurants: page.restaurants),
          );
        }
      },
    );
  }

  Future<RestaurantsPage> get _getRestauratnsPage async {
    final lat = _localStorage.latitude.toString();
    final lng = _localStorage.longitude.toString();
    return RestaurantApi()
        .getDBRestaurantsPageFromBackend(latitude: lat, longitude: lng);
  }

  Future<void> get _getPopularRestaurants async {
    final lat = _localStorage.latitude.toString();
    final lng = _localStorage.longitude.toString();
    final restaurants = await RestaurantApi().getPopularRestaurantsFromBackend(
      latitude: lat,
      longitude: lng,
    );
    popularRestaurants
      ..clear()
      ..addAll(restaurants);
  }

  Future<void> get _getRestaurantsTags async {
    final lat = _localStorage.latitude.toString();
    final lng = _localStorage.longitude.toString();
    final tags = await RestaurantApi().getRestaurantsTags(
      latitude: lat,
      longitude: lng,
    );
    restaurantsTags
      ..clear()
      ..addAll(tags);
  }

  // Everything that is commented in this file and everything that is connected
  // to it it means that I no longer use this methonds due to unavailability to
  // use Google maps APIs due to billing problems.
  //
  // So, instead of it I use my own Backend server from where I can get my own
  // Restaurants and other data.

  // Future<void> filterRestaurantsByTag(String tagName) async {
  //   final restaurants =
  //       await RestaurantApi().getRestaurantsByTag(tagName: tagName);
  //   filteredRestaurantsByTag = restaurants;
  // }
  Future<List<GoogleRestaurant>> filterRestaurantsByTag(String tagName) async {
    final lat = _localStorage.latitude.toString();
    final lng = _localStorage.longitude.toString();
    return RestaurantApi().getRestaurantsByTag(
      tagName: tagName,
      latitude: lat,
      longitude: lng,
    );
  }

  // Future<RestaurantsPage> fetchFirstPage(
  //     String? pageToken, bool forMainPage) async {
  //   final firstPage =
  //       await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
  //   _doSomeFilteringOnPage(firstPage.restaurants);
  //   return firstPage;
  // }

  // void _fetchFirstPage(String? pageToken, bool forMainPage) async {
  //   logger.w('Fetching for first page by Page Token $pageToken');
  //   // final firstPage =
  //   //     await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
  //   final firstPage = await _getRestauratnsPage;
  //   _doSomeFilteringOnPage(firstPage.restaurants);
  //   // restaurants = firstPage.restaurants;
  //   final hasMore = firstPage.nextPageToken == null ? false : true;
  //   _restaurantsPageSubject.add(
  //     RestaurantsPage(
  //       restaurants: firstPage.restaurants,
  //       errorMessage: firstPage.errorMessage,
  //       hasMore: hasMore,
  //       nextPageToken: firstPage.nextPageToken,
  //       status: firstPage.status,
  //     ),
  //   );
  //   // logger.w('GOT SOME RESTAURANTS ${firstPage.restaurants}');
  // }

  Future<void> fetchAllRestaurantsByLocation({
    bool updateByNewLatLng = false,
    double? lat,
    double? lng,
  }) async {
    if (updateByNewLatLng && lat != null && lng != null) {
      /// Clearing all and then fetching again for new restaurants with new
      /// lat and lng.
      allRestaurants.clear();
      await _getAllRestaurants(lat: lat, lng: lng);
    } else {
      await _getRestaurantsTags;
      // _getAllRestaurants(),
      await _getPopularRestaurants;
    }
  }

  Future<void> _getAllRestaurants({double? lat, double? lng}) async {
    // final page = await _restaurantService.getRestaurantsPage(
    //   pageToken,
    //   true,
    //   lat: lat,
    //   lng: lng,
    // );
    logger.w('Getting all restaurants');
    final page = await _getRestauratnsPage;
    allRestaurants.addAll(page.restaurants);
    _filterPage(page);
    _restaurantsPageSubject.add(
      RestaurantsPage(
        restaurants: page.restaurants,
      ),
    );
    // pageToken = page.nextPageToken;
    // final hasMore = page.nextPageToken == null ? false : true;
    // logger.w(
    //     'All restaurants $allRestaurants and length
    //  is ${allRestaurants.length}');
    // await Future.delayed(const Duration(milliseconds: 1800));
    // if (hasMore) {
    //   logger.w('Fetching for one more time');
    //   fetchAllRestaurantsByLocation();
    // } else {
    //   _restaurantsPageSubject.add(
    //     RestaurantsPage(
    //       restaurants: allRestaurants,
    //       hasMore: false,
    //     ),
    //   );
    // }
  }

  Future<void> updateRestaurants(
    double lat,
    double lng,
    String? pageToken, {
    required bool forMainPage,
  }) async {
    logger.w('Updating restaurants with new Lat and Lng by $pageToken');
    final updatedPage = await _restaurantService.getRestaurantsPage(
      pageToken,
      mainPage: forMainPage,
      lat: lat,
      lng: lng,
    );
    _filterPage(updatedPage);
    // restaurants = firstPage.restaurants;
    final hasMore = !(updatedPage.nextPageToken == null);
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

  // Future<RestaurantsPage> getNextRestaurantsPage(
  //     String? pageToken, bool forMainPage) async {
  //   logger.w('FETCHING FOR NEXT PAGE by Page Token $pageToken');
  //   final nextPage =
  //       await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
  //   _doSomeFilteringOnPage(nextPage.restaurants);
  //   // restaurants.addAll(nextPage.restaurants);
  //   return nextPage;
  // }

  void _filterPage(
    RestaurantsPage page,
  ) {
    // Removing if permanently closed
    page.restaurants
      ..removeWhere(
        (restaurant) =>
            restaurant.name == 'Ne Rabotayet' ||
            (restaurant.permanentlyClosed ?? false),
      )
      ..removeDuplicates(
        by: (restaurant) => restaurant.name,
      )
      ..whereMoveToTheFront((restaurant) {
        final rating = restaurant.rating as double;
        return rating >= 4.8 || restaurant.userRatingsTotal! >= 300;
      })
      ..whereMoveToTheEnd((restaurant) {
        if (restaurant.rating != null) {
          final rating = restaurant.rating as double;
          return rating < 4.5 || restaurant.userRatingsTotal == null;
        }
        return false;
      });
  }
}
