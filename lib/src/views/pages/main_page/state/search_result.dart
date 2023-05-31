import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show GoogleRestaurant;

@immutable
abstract class SearchResult {
  const SearchResult();
}

@immutable
class SearchResultsNoResults implements SearchResult {
  const SearchResultsNoResults();
}

@immutable
class SearchResultsWithResults implements SearchResult {
  const SearchResultsWithResults(this.restaurants);
  final List<GoogleRestaurant> restaurants;
}

@immutable
class SearchResultsLoading implements SearchResult {
  const SearchResultsLoading();
}

@immutable
class SearchResultsError implements SearchResult {
  const SearchResultsError(this.error);
  final Object error;
}
