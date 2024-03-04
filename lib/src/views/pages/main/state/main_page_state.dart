import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/restaurant.dart';

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
  const MainPageError({
    required this.error,
  });
  final Object? error;
}

@immutable
class MainPageWithRestaurants extends MainPageState {
  const MainPageWithRestaurants({
    required this.restaurants,
  });
  final List<Restaurant> restaurants;
}

@immutable
class MainPageWithNoRestaurants extends MainPageState {
  const MainPageWithNoRestaurants();
}

@immutable
class MainPageWithFilteredRestaurants extends MainPageState {
  const MainPageWithFilteredRestaurants({
    required this.filteredRestaurants,
  });
  final List<Restaurant> filteredRestaurants;
}
