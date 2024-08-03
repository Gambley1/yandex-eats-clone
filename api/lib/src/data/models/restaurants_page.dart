import 'package:equatable/equatable.dart';
import 'package:yandex_food_api/client.dart';

/// {@template restaurants_page}
/// A representation of Restaurants page.
/// {@endtemplate}
class RestaurantsPage extends Equatable {
  /// {@macro restaurants_page}
  const RestaurantsPage({
    required this.restaurants,
    required this.totalRestaurants,
    required this.page,
    required this.hasMore,
  });

  /// {@macro restaurants_page.empty}
  const RestaurantsPage.empty()
      : this(
          restaurants: const [],
          totalRestaurants: 0,
          page: 0,
          hasMore: true,
        );

  /// The list of restaurants inside the page.
  final List<Restaurant> restaurants;

  /// The total number of restaurants in the feed.
  final int totalRestaurants;

  /// The current page of the feed.
  final int page;

  /// Whether current page has more restaurants to load.
  final bool hasMore;

  @override
  List<Object> get props => [restaurants, totalRestaurants, page, hasMore];

  /// Copies the current [RestaurantsPage] instance and overrides the provided
  /// properties.
  RestaurantsPage copyWith({
    List<Restaurant>? restaurants,
    int? totalRestaurants,
    int? page,
    bool? hasMore,
  }) {
    return RestaurantsPage(
      restaurants: restaurants ?? this.restaurants,
      totalRestaurants: totalRestaurants ?? this.totalRestaurants,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
