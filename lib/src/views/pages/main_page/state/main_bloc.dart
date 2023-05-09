import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show FicListExtension;
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show LocalStorage, RestaurantApi, RestaurantService, Tag, logger;
import 'package:rxdart/rxdart.dart'
    show
        BehaviorSubject,
        OnErrorExtensions,
        Rx,
        StartWithExtension,
        SwitchIfEmptyExtension,
        SwitchMapExtension;

import 'main_page_state.dart';

class MainBloc {
  static final MainBloc _instance = MainBloc._privateConstructor();

  factory MainBloc() => _instance;

  late final RestaurantService _restaurantService;
  late final LocalStorage _localStorage;

  MainBloc._privateConstructor() {
    _restaurantService = RestaurantService();
    _localStorage = LocalStorage.instance;
    // _fetchFirstPage(null, true);
    fetchAllRestaurantsByLocation();
  }

  final _restaurantsPageSubject =
      BehaviorSubject<RestaurantsPage>.seeded(RestaurantsPage(restaurants: []));
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
      _restaurantsPageSubject.stream;

  List<GoogleRestaurant> allRestaurants = [];
  List<GoogleRestaurant> popularRestaurants = [];
  List<GoogleRestaurant> filteredRestaurantsByTag = [];
  List<Tag> restaurantsTags = [];
  String? pageToken;

  void refresh() {
    if (popularRestaurants.isNotEmpty) {
      _restaurantsPageSubject.add(
        RestaurantsPage(restaurants: []),
      );
    } else {
      _getPopularRestaurants;
      _restaurantsPageSubject.add(
        RestaurantsPage(restaurants: []),
      );
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
  /// the result from getRestaurantsPageFromBackend() method. Whether it's empty
  /// returning MainPageStateWithNoRestaurants. If it has error returning MainPageError
  /// and if it has restaurants returning MainPageWithRestauraurants.
  Stream<MainPageState> get mainPageState {
    return _restaurantsPageSubject.distinct().switchMap(
      (page) {
        if (page.restaurants.isEmpty) {
          return Rx.fromCallable(() => RestaurantApi()
              .getDBRestaurantsPageFromBackend()
              .timeout(const Duration(seconds: 5))).map(
            (newPage) {
              if (newPage.restaurants.isEmpty) {
                return const MainPageWithNoRestaurants();
              }
              if (newPage.errorMessage != null) {
                return MainPageError(error: newPage.errorMessage);
              }
              page.restaurants.clear();
              page.restaurants.addAll(newPage.restaurants);
              return MainPageWithRestaurants(restaurants: newPage.restaurants);
            },
          ).onErrorReturnWith(
            (error, stackTrace) {
              logger.e(stackTrace);
              logger.e(error);
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

    // final filteredRestaurants = _filterRestaurantsByTagSubject
    //     .distinct()
    //     .switchMap<MainPageState>((tag) {
    //   if (tag.isEmpty) {
    //     return Stream.value(const MainPageWithNoRestaurants());
    //   }
    //   return Rx.fromCallable(() => RestaurantApi()
    //       .getRestaurantsByTag(tagName: tag)
    //       .timeout(const Duration(seconds: 3))).map(
    //     (filteredRestaurants) {
    //       final withoutTags =
    //           filteredRestaurants.map((e) => e.copyWith(tags: [])).toList();
    //       logger.w('Filtered Restaurants from Stream $filteredRestaurants');
    //       if (filteredRestaurants.isEmpty) {
    //         return const MainPageWithNoRestaurants();
    //       }
    //       return MainPageWithFilteredRestaurants(
    //           filteredRestaurants: withoutTags);
    //     },
    //   ).onErrorReturnWith(
    //     (error, stackTrace) {
    //       logger.e(stackTrace);
    //       logger.e(error);
    //       return MainPageError(error: error);
    //     },
    //   ).startWith(const MainPageLoading());
    // });

    // return Rx.combineLatest2(
    //   mainPageState$L,
    //   filteredRestaurants,
    //   (mainState, filteredState) {
    //     logger.w('Rx Combine Latest main state is $mainState');
    //     logger.w('Rx Combine Latest filtered state is $filteredState');
    //     if (filteredState is MainPageWithFilteredRestaurants) {
    //       return filteredState;
    //     }
    //     return mainState;
    //   },
    // );
  }

  Future<RestaurantsPage> get _getRestauratnsPage async {
    logger.w('Get Restaurants Page from Backend');
    final page = await RestaurantApi().getRestaurantsPageFromBackend();
    return page;
  }

  Future<void> get _getPopularRestaurants async {
    logger.w('Get popular Restaurants');
    final restaurants =
        await RestaurantApi().getPopularRestaurantsFromBackend();
    popularRestaurants.clear();
    popularRestaurants.addAll(restaurants);
  }

  Future<void> get _getRestaurantsTags async {
    logger.w('Get Restaurants Tags');
    final tags = await RestaurantApi().getRestaurantsTags();
    logger.w('Tags $tags');
    restaurantsTags.addAll(tags);
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
  Future<List<GoogleRestaurant>> filterRestaurantsByTag(String tagName) async =>
      await RestaurantApi().getRestaurantsByTag(tagName: tagName);

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

  void fetchAllRestaurantsByLocation(
      {bool updateByNewLatLng = false, double? lat, double? lng}) async {
    if (updateByNewLatLng && lat != null && lng != null) {
      /// Clearing all and then fetching again for new restaurants with new lat and lng.
      allRestaurants.clear();
      await Future.wait(
        [
          _getAllRestaurants(lat: lat, lng: lng),
        ],
      );
    } else {
      await Future.wait(
        [
          _getRestaurantsTags,
          // _getAllRestaurants(),
          _getPopularRestaurants,
        ],
      );
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
    _doSomeFilteringOnPage(allRestaurants);
    _restaurantsPageSubject.add(
      RestaurantsPage(
        restaurants: page.restaurants,
      ),
    );
    // pageToken = page.nextPageToken;
    // final hasMore = page.nextPageToken == null ? false : true;
    // logger.w(
    //     'All restaurants $allRestaurants and length is ${allRestaurants.length}');
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

  // Future<RestaurantsPage> getNextRestaurantsPage(
  //     String? pageToken, bool forMainPage) async {
  //   logger.w('FETCHING FOR NEXT PAGE by Page Token $pageToken');
  //   final nextPage =
  //       await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
  //   _doSomeFilteringOnPage(nextPage.restaurants);
  //   // restaurants.addAll(nextPage.restaurants);
  //   return nextPage;
  // }

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
