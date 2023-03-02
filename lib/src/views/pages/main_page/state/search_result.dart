import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart';

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
  final List<Restaurant> restaurants;
  const SearchResultsWithResults(this.restaurants);
}

@immutable
class SearchResultsLoading implements SearchResult {
  const SearchResultsLoading();
}

@immutable
class SearchResultsError implements SearchResult {
  final Object error;
  const SearchResultsError(this.error);
}
