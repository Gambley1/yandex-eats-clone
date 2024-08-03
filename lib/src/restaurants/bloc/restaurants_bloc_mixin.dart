part of 'restaurants_bloc.dart';

// A typedef representing the result of a paginated feed.
typedef PaginatedRestaurantsResult
    = Future<({int newPage, bool hasMore, List<Restaurant> restaurants})>;

mixin RestaurantsBlocMixin on Bloc<RestaurantsEvent, RestaurantsState> {
  int get pageLimit => 4;

  RestaurantsRepository get restaurantsRepository;

  PaginatedRestaurantsResult fetchRestaurantsPage({
    int page = 0,
  }) async {
    final currentPage = page;
    final restaurants = await restaurantsRepository.getRestaurants(
      location: state.location,
      offset: currentPage * pageLimit,
      limit: pageLimit,
    );
    final newPage = currentPage + 1;
    final hasMore = restaurants.length >= pageLimit;

    return (newPage: newPage, hasMore: hasMore, restaurants: restaurants);
  }
}
