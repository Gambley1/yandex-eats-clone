import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class LocationBloc {
  final Sink<String> search;
  final Stream<LocationResult?> result;

  void dispose() {
    search.close();
  }

  factory LocationBloc({
    required LocationApi locationApi,
  }) {
    final locationSubject = BehaviorSubject<String>();

    final result = locationSubject
        .distinct()
        .debounceTime(const Duration(milliseconds: 400))
        .switchMap<LocationResult?>(
      (String term) {
        logger.w(term);
        if (term.isNotEmpty && term.length >= 2) {
          return Rx.fromCallable(() => locationApi.getAutoComplete(query: term))
              .map((autoCompletes) => autoCompletes.isNotEmpty
                  ? LocationResultWithResults(autoCompletes)
                  : const LocationResultNoResults())
              .startWith(const LocationResultLoading())
              .onErrorReturnWith((error, stacktrace) {
            logger.e('${error.toString()}, ${stacktrace.toString()}');
            return LocationResultError(error);
          });
        } else {
          return Stream<LocationResult?>.value(null);
        }
      },
    );

    return LocationBloc._privateConstrucator(
      search: locationSubject.sink,
      result: result,
    );
  }

  const LocationBloc._privateConstrucator({
    required this.search,
    required this.result,
  });
}
