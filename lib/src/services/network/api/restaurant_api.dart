import 'package:dio/dio.dart' show Dio, DioError, DioErrorType, LogInterceptor;
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger_server/api.dart' as server;
import 'package:papa_burger/src/restaurant.dart'
    show
        LocalStorage,
        MainBloc,
        Mapper,
        Restaurant,
        RestaurantsPage,
        Tag,
        UrlBuilder,
        defaultTimeout,
        logger,
        restaurantsJson;

class RestaurantApi {
  RestaurantApi({
    Dio? dio,
    UrlBuilder? urlBuilder,
  })  : _dio = dio ?? Dio(),
        _urlBuilder = urlBuilder ?? UrlBuilder() {
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
    ));
    _dio.options.connectTimeout = defaultTimeout;
    _dio.options.receiveTimeout = defaultTimeout;
    _dio.options.sendTimeout = defaultTimeout;
  }

  final Dio _dio;
  final UrlBuilder _urlBuilder;

  static final LocalStorage _localStorage = LocalStorage.instance;
  static const radius = 10000;

  late final lat = _localStorage.latitude;
  late final lng = _localStorage.longitude;

  Future<RestaurantsPage> getRestaurantsPageFromBackend() async {
    try {
      final apiClient = server.ApiClient();

      final clientRestaurants = await apiClient.getAllRestaurants();
      logger.w("Client Restaurants $clientRestaurants");
      final restaurants =
          clientRestaurants.map(GoogleRestaurant.fromBackend).toList();

      logger.w('All Restaurants $restaurants');
      return RestaurantsPage(restaurants: restaurants);
    } catch (e) {
      logger.e(e.toString());
      return RestaurantsPage(restaurants: [], errorMessage: e.toString());
    }
  }

  Future<RestaurantsPage> getDBRestaurantsPageFromBackend() async {
    try {
      final apiClient = server.ApiClient();

      final clientRestaurants = await apiClient.getAllDBRestaurants();
      logger.w("Client Restaurants $clientRestaurants");
      final restaurants =
          clientRestaurants.map(GoogleRestaurant.fromDb).toList();

      logger.w('All Restaurants $restaurants');
      return RestaurantsPage(restaurants: restaurants);
    } catch (e) {
      logger.e(e.toString());
      return RestaurantsPage(restaurants: [], errorMessage: e.toString());
    }
  }

  Future<List<GoogleRestaurant>> getPopularRestaurantsFromBackend() async {
    final apiClient = server.ApiClient();

    final clientRestaurants = await apiClient.getPopularRestaurants();
    final restaurants = clientRestaurants.map(GoogleRestaurant.fromDb).toList();

    logger.w('Popular Restaurants $restaurants');
    return restaurants;
  }

  Future<RestaurantsPage> getRestaurantsPage(String? pageToken, bool mainPage,
      {double? lat$, double? lng$}) async {
    String url = _urlBuilder.buildNearbyPlacesUrl(
      lat: lat$ ?? lat,
      lng: lng$ ?? lng,
      radius: 10000,
      nextPageToken: pageToken,
      forMainPage: mainPage,
    );

    try {
      final response = await _dio.get<dynamic>(url);
      final data = response.data;

      final status = data['status'];

      if (status == 'ZERO_RESULTS') {
        logger.w(
            'Indicating that the search was successful but returned no results.');
        return RestaurantsPage(
            restaurants: [], errorMessage: 'Zero Results', status: status);
      }
      if (status == 'INVALID_REQUEST') {
        logger.w(
            'Indicating the API request was malformed, generally due to the missing input parameter. ${status.toString()}');
        throw Exception(
            'Indicating the API request was malformed, generally due to the missing input parameter. ${status.toString()}');
      }
      if (status == 'OVER_QUERY_LIMIT') {
        logger.w(
            'The monthly \$200 credit, or a self-imposed usage cap, has been exceeded. ${status.toString()}');
        throw Exception(
            'The monthly \$200 credit, or a self-imposed usage cap, has been exceeded. ${status.toString()}');
      }
      if (status == 'REQUEST_DENIED') {
        logger.w('The request is missing an API key. ${status.toString()}');
        return RestaurantsPage(
          restaurants: [],
          errorMessage: 'Request denied',
          status: status,
        );
      }
      if (status == 'UNKNOWN_ERROR') {
        logger.e('Unknown error. ${status.toString()}');
        return RestaurantsPage(
            restaurants: [], errorMessage: 'Unknown Error', status: status);
      }

      final restaurants = getNearbyRestaurantsByLocation(data);
      final pageToken = getNextPageToken(data);

      return RestaurantsPage(
        nextPageToken: pageToken,
        restaurants: restaurants,
      );
    } on DioError catch (error) {
      logger.e(error.error, error.stackTrace);
      if (error.type == DioErrorType.connectionTimeout) {
        return RestaurantsPage(
          restaurants: [],
          errorMessage: 'Connection Timeout',
          status: 'Connection Timeout',
        );
      }
      return RestaurantsPage(
        restaurants: [],
        errorMessage: 'Unknown error',
        status: 'Unknown error',
      );
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  String? getNextPageToken(dynamic data) {
    try {
      final pageToken = data['next_page_token'];

      return pageToken;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  List<GoogleRestaurant> getNearbyRestaurantsByLocation(dynamic data) {
    try {
      final results = data['results'] as List;

      final restaurants = results
          .map<GoogleRestaurant>(
            (json) => GoogleRestaurant.fromJson(json),
          )
          .toList();
      return restaurants;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  List<Restaurant> getListRestaurants() {
    try {
      final json = restaurantsJson();
      final restaurants = json['restaurants'] as List;
      return restaurants.isNotEmpty
          ? restaurants
              .map<Restaurant>(
                (rest) => Mapper.restaurantFromJson(rest),
              )
              .toList()
          : [];
    } catch (e) {
      logger.e(e.toString(), 'restaurant error');
      return [];
    }
  }

  Restaurant getRestaurantById(int id) {
    try {
      logger.i('getting restaurant by id $id');
      final restaurants = getListRestaurants();
      if (id == 0) return const Restaurant.empty();
      final restaurantById =
          restaurants.firstWhere((restaurant) => restaurant.id == id);
      return restaurantById;
    } catch (e) {
      logger.e(e.toString());
      return const Restaurant.empty();
    }
  }

  GoogleRestaurant getRestaurantByPlaceId(String placeId) {
    try {
      logger.i('getting restaurant by place id $placeId');
      if (placeId.isEmpty) return const GoogleRestaurant.empty();
      final restaurants = MainBloc().restaurantsPage$.restaurants;
      final restaurantById = restaurants.firstWhere(
        (restaurant) => restaurant.placeId == placeId,
        orElse: () => const GoogleRestaurant.empty(),
      );
      return restaurantById;
    } catch (e) {
      logger.e(e.toString());
      return const GoogleRestaurant.empty();
    }
  }

  Future<List<Tag>> getRestaurantsTags() async {
    try {
      final apiClient = server.ApiClient();
      final clientTags = await apiClient.getRestaurantsTags();

      final tags = clientTags
          .map(
            (tag) => Tag(
              name: tag.name,
              imageUrl: tag.imageUrl,
            ),
          )
          .toList();
      return tags;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<List<GoogleRestaurant>> getRestaurantsByTag({
    required String tagName,
  }) async {
    try {
      final apiClient = server.ApiClient();
      final clientRestaurants = await apiClient.getRestaurantsByTag(tagName);

      final restaurants =
          clientRestaurants.map(GoogleRestaurant.fromDb).toList();

      return restaurants;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }
}
