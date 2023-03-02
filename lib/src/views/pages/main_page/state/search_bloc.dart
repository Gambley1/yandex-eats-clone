import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  void dispose() {
    search.close();
  }

  factory SearchBloc({required SearchApi api}) {
    final textChanges = BehaviorSubject<String>(
        onListen: () => logger.i('Listens to the search stream'),
        onCancel: () => logger.w('Cancels search stream'));

    final results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((String term) {
      if (term.isNotEmpty && term.length >= 2) {
        return Rx.fromCallable(() => api.search(term))
            .delay(const Duration(milliseconds: 500))
            .map((restaurants) => restaurants.isNotEmpty
                ? SearchResultsWithResults(restaurants)
                : const SearchResultsNoResults())
            .onErrorReturnWith((error, _) => SearchResultsError(error))
            .startWith(const SearchResultsLoading());
      } else {
        return Stream<SearchResult?>.value(null);
      }
    });

    return SearchBloc._privateConstructor(
        search: textChanges.sink, results: results);
  }

  const SearchBloc._privateConstructor({
    required this.search,
    required this.results,
  });
}
