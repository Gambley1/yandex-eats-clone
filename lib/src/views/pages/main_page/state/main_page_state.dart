import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';

@immutable
abstract class MainPageState {
  const MainPageState();
}

@immutable
class MainPageLoading extends MainPageState {
  const MainPageLoading();
}

@immutable
class MainPageError extends MainPageState {
  final Object? error;
  const MainPageError({
    required this.error,
  });
}

@immutable
class MainPageWithRestaurants extends MainPageState {
  final List<GoogleRestaurant> restaurants;
  const MainPageWithRestaurants({
    required this.restaurants,
  });
}

@immutable
class MainPageWithNoRestaurants extends MainPageState {
  const MainPageWithNoRestaurants();
}

@immutable
class MainPageWithFilteredRestaurants extends MainPageState {
  final List<GoogleRestaurant> filteredRestaurants;
  const MainPageWithFilteredRestaurants({
    required this.filteredRestaurants,
  });
}
