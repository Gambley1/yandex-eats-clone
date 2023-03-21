import 'package:dio/dio.dart' show Dio, DioError, DioErrorType, LogInterceptor;
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        GoogleRestaurantDetails,
        LocalStorage,
        Mapper,
        Restaurant,
        RestaurantsPage,
        Tag,
        UrlBuilder,
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
    _dio.options.connectTimeout = 10 * 1000;
    _dio.options.receiveTimeout = 10 * 1000;
    _dio.options.sendTimeout = 10 * 1000;
  }

  final Dio _dio;
  final UrlBuilder _urlBuilder;

  static List<String> imageUrls = [];
  static List<GoogleRestaurantDetails> restaurantsDetails = [];
  static final LocalStorage _localStorage = LocalStorage.instance;
  static const radius = 10000;

  List<Restaurant>? restaurants;

  late final lat = _localStorage.latitude;
  late final lng = _localStorage.longitude;

  Future<RestaurantsPage> getRestaurantsPage(String? pageToken, bool mainPage,
      {double? lat$, double? lng$}) async {
    String url = _urlBuilder.buildNearbyPlacesUrl(
      lat: lat$ ?? lat,
      lng: lng$ ?? lng,
      radius: 10000,
      nextPageToken: pageToken,
      forMainPage: mainPage,
    );

    // logger.w('Url is $url');

    try {
      final response = await _dio.get(url);
      final data = response.data;

      final status = data['status'];

      if (status == 'ZERO_RESULTS') {
        logger.w(
            'Indicating that the search was successful but returned no results.');
        return RestaurantsPage(
          restaurants: [],
          errorMessage: 'Zero Results',
        );
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
        throw Exception(
            'The request is missing an API key. ${status.toString()}');
      }
      if (status == 'UNKNOWN_ERROR') {
        logger.e('Unknown error. ${status.toString()}');
        return RestaurantsPage(
          restaurants: [],
          errorMessage: 'Unknown Error',
        );
      }

      final restaurants = getNearbyRestaurantsByLocation(data);
      final pageToken = getNextPageToken(data);

      return RestaurantsPage(
        nextPageToken: pageToken,
        restaurants: restaurants,
      );
    } on DioError catch (error) {
      logger.e(error.error, error.stackTrace);
      if (error.type == DioErrorType.connectTimeout) {
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

  Future<GoogleRestaurantDetails> getRestaurantDetails(String placeId) async {
    final url = _urlBuilder.buildRestaurantDetailsUrl(placeId: placeId);
    try {
      final response = await _dio.get(url);
      final data = response.data;

      final result = data['result'];
      return GoogleRestaurantDetails.fromJson(result);
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  String getImageUrlsByPhotoReference(String photoReference, int? width) {
    String imageUrl = '';

    int maxwidth = width ?? 400;
    if (photoReference.isEmpty) {
      imageUrl =
          'https://static.heyyou.io/images/vendor/cover/default_vendor_cover-640x300.jpg';
    } else {
      imageUrl = _urlBuilder.buildRestaurantPhotoUlr(
        photoReference: photoReference,
        maxwidth: maxwidth,
      );
    }
    return imageUrl;
  }

  Future<List<GoogleRestaurantDetails>> getRestaurantsDetails(
      dynamic results) async {
    List<GoogleRestaurantDetails> restaurantsDetails$ = [];
    String placeId = '';
    for (var i = 0; i < results.length; i++) {
      final placeId$ = results[i]['place_id'];
      placeId = placeId$;
      final restaurantDetails = await getRestaurantDetails(placeId);
      restaurantsDetails$.add(restaurantDetails);
      restaurantsDetails = restaurantsDetails$;
    }
    return restaurantsDetails$;
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

  GoogleRestaurant getRestaurantByPlaceId(
      String placeId, List<GoogleRestaurant> restaurants) {
    try {
      logger.i('getting restaurant by id $placeId');
      if (placeId.isEmpty) return const GoogleRestaurant.empty();
      final restaurantById =
          restaurants.firstWhere((restaurant) => restaurant.placeId == placeId);
      return restaurantById;
    } catch (e) {
      logger.e(e.toString());
      return const GoogleRestaurant.empty();
    }
  }

  List<Tag> getRestaurantsTags() {
    try {
      final restaurants = getListRestaurants();
      final restaurantsTags = restaurants.map((e) => e.tags).toList();

      final restaurantsCateg = restaurantsTags.expand((tag) => tag).toList();

      final Set<Tag> setRestaurantName = Set.from(restaurantsCateg);
      final namesOfCategories = setRestaurantName.toList();
      return namesOfCategories;
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }

  List<Restaurant> getRestaurantsByTag({
    required List<String> categName,
    required int index,
  }) {
    try {
      final restaurants = getListRestaurants();
      final restaurantTags = getRestaurantsTags();
      final filteredRestaurants = restaurants
          .where((restaurant) =>
              restaurantTags.map((tag) => tag.name).contains(categName[index]))
          .toList();
      return filteredRestaurants;
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }
}
