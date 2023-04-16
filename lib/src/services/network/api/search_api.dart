import 'dart:convert' show json;

import 'package:dio/dio.dart' show Dio, LogInterceptor;
import 'package:papa_burger/src/restaurant.dart'
    show GoogleRestaurant, MainPageService, TrimmedConvertedStringContains, UrlBuilder;

class SearchApi {
  SearchApi({
    Dio? dio,
    UrlBuilder? urlBuilder,
    MainPageService? mainPageService,
  })  : _dio = dio ?? Dio(),
        _urlBuilder = urlBuilder ?? UrlBuilder(),
        _mainPageService = mainPageService ?? MainPageService() {
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
    ));
    _dio.options.connectTimeout = 5 * 1000;
    _dio.options.receiveTimeout = 5 * 1000;
    _dio.options.sendTimeout = 5 * 1000;
  }

  final Dio _dio;
  final UrlBuilder _urlBuilder;
  final MainPageService _mainPageService;

  List<GoogleRestaurant>? _cachedRestaurants;

  Future<List<GoogleRestaurant>> search(String searchTerm) async {
    final term = searchTerm.trim().toLowerCase();

    final cachedResults = _exactRestaurants(term);
    if (cachedResults != null) {
      return cachedResults;
    }
    final restaurants = _mainPageService.mainBloc.allRestaurants;
    _cachedRestaurants = restaurants.toList();

    return _exactRestaurants(term) ?? [];
  }

  List<GoogleRestaurant>? _exactRestaurants(String term) {
    final cachedRestaurants = _cachedRestaurants;

    if (cachedRestaurants != null) {
      List<GoogleRestaurant> result = [];
      for (final restaurant in cachedRestaurants) {
        if (restaurant.name.trimmedContains(term)) {
          result.add(restaurant);
        }
      }
      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> getRestaurants([String? url]) async {
    final urlParsed = url ?? _urlBuilder.dummyStringOfRestaurants();
    return await _dio
        .get(urlParsed)
        .then((response) => response.data)
        .then((jsonString) => json.decode(jsonString) as List<dynamic>);
  }
}
