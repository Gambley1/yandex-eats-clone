import 'package:papa_burger/src/views/pages/main/state/main_bloc.dart';
import 'package:papa_burger_server/api.dart' as server;
import 'package:shared/shared.dart';

class SearchApi {
  SearchApi();

  List<Restaurant>? _cachedRestaurants;

  Future<List<Restaurant>> search(
    String searchTerm, {
    required String latitude,
    required String longitude,
  }) async {
    final term = searchTerm.trim().toLowerCase().replaceAll(' ', '');

    final cachedResults =
        await _exactRestaurants(term, latitude: latitude, longitude: longitude);
    if (cachedResults != null) {
      return cachedResults;
    }
    final restaurants = MainBloc().allRestaurants;
    _cachedRestaurants = restaurants;

    return await _exactRestaurants(
          term,
          latitude: latitude,
          longitude: longitude,
        ) ??
        [];
  }

  Future<List<Restaurant>?> _exactRestaurants(
    String term, {
    required String latitude,
    required String longitude,
  }) async {
    final cachedRestaurants = _cachedRestaurants;
    final apiClient = server.ApiClient();

    if (cachedRestaurants != null) {
      final clientRestaurants = await apiClient.getRestaurantsBySearchQuery(
        term,
        latitude: latitude,
        longitude: longitude,
      );
      final result = clientRestaurants.map(Restaurant.fromDb).toList();
      return result;
    } else {
      return null;
    }
  }
}
