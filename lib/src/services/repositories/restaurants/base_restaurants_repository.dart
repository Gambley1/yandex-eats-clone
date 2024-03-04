import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/models.dart';

@immutable
abstract class BaseRestaurantsRepository {
  Future<RestaurantsPage> getRestaurantsPage({
    required double latitude,
    required double longitude,
  });
  Future<Restaurant> getRestaurantByPlaceId(
    String placeId, {
    required String latitude,
    required String longitude,
  });
}
