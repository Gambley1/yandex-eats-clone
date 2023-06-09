import 'package:dio/dio.dart' show Dio, LogInterceptor;
import 'package:papa_burger/src/restaurant.dart'
    show GoogleRestaurant, MainPageService, defaultTimeout, logger;
import 'package:papa_burger_server/api.dart' as server;

class SearchApi {
  SearchApi({
    Dio? dio,
    MainPageService? mainPageService,
  })  : _dio = dio ?? Dio(),
        _mainPageService = mainPageService ?? MainPageService() {
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
      ),
    );
    _dio.options.connectTimeout = defaultTimeout;
    _dio.options.receiveTimeout = defaultTimeout;
    _dio.options.sendTimeout = defaultTimeout;
  }

  final Dio _dio;
  final MainPageService _mainPageService;

  List<GoogleRestaurant>? _cachedRestaurants;

  Future<List<GoogleRestaurant>> search(
    String searchTerm, {
    required String latitude,
    required String longitude,
  }) async {
    final term = searchTerm.trim().toLowerCase().replaceAll(' ', '');

    final cachedResults =
        await _exactRestaurants(term, latitude: latitude, longitude: longitude);
    if (cachedResults != null) {
      logger.w('Returning the same restaurants/restaurant');
      return cachedResults;
    }
    logger.w('Returning new restaurants');
    final restaurants = _mainPageService.mainBloc.allRestaurants;
    _cachedRestaurants = restaurants;

    return await _exactRestaurants(
          term,
          latitude: latitude,
          longitude: longitude,
        ) ??
        [];
  }

  Future<List<GoogleRestaurant>?> _exactRestaurants(
    String term, {
    required String latitude,
    required String longitude,
  }) async {
    final cachedRestaurants = _cachedRestaurants;
    final apiClient = server.ApiClient();
    logger.w('Term $term');

    if (cachedRestaurants != null) {
      final clientRestaurants = await apiClient.getRestaurantsBySearchQuery(
        term,
        latitude: latitude,
        longitude: longitude,
      );
      final result = clientRestaurants.map(GoogleRestaurant.fromDb).toList();
      return result;
    } else {
      return null;
    }
  }
}
