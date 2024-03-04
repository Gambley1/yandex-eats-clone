import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/services/network/api/search_api.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:papa_burger/src/views/pages/main/state/search_result.dart';
import 'package:rxdart/rxdart.dart'
    show
        BehaviorSubject,
        DebounceExtensions,
        DelayExtension,
        OnErrorExtensions,
        Rx,
        StartWithExtension,
        SwitchMapExtension;

@immutable
class SearchBloc {
  factory SearchBloc({required SearchApi api}) {
    final textChanges = BehaviorSubject<String>();

    final results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((String term) {
      if (term.isNotEmpty && term.length >= 2) {
        final lat = LocalStorage().latitude.toString();
        final lng = LocalStorage().longitude.toString();
        return Rx.fromCallable(
          () => api
              .search(
                term,
                latitude: lat,
                longitude: lng,
              )
              .timeout(const Duration(seconds: 5)),
        )
            .delay(const Duration(milliseconds: 500))
            .map(
              (restaurants) => restaurants.isNotEmpty
                  ? SearchResultsWithResults(restaurants)
                  : const SearchResultsNoResults(),
            )
            .onErrorReturnWith((error, _) => SearchResultsError(error))
            .startWith(const SearchResultsLoading());
      } else {
        return Stream<SearchResult?>.value(null);
      }
    });

    return SearchBloc._privateConstructor(
      search: textChanges.sink,
      results: results,
    );
  }

  const SearchBloc._privateConstructor({
    required this.search,
    required this.results,
  });
  final Sink<String> search;
  final Stream<SearchResult?> results;

  void dispose() {
    search.close();
  }
}
