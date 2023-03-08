import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class LocationBloc {
  final Sink<String> search;
  final Stream<LocationResult?> result;
  final Stream<String> location;
  final Stream<String> address;

  void dispose() {
    search.close();
  }

  factory LocationBloc({
    required LocationApi locationApi,
    required LocalStorage localStorage,
  }) {
    final autocompleteSubject = BehaviorSubject<String>();
    final locationSubject =
        BehaviorSubject<String>.seeded('No location, please pick one.');

    final result = autocompleteSubject
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

    Stream<String> location() {
      return locationSubject.distinct().map((location) {
        final location$ = localStorage.getLocation;
        location = location$;
        return location;
      });
    }

    Stream<String> address() {
      return locationSubject.distinct().map((address) {
        final address$ = localStorage.getAddress;
        address = address$;
        return address;
      });
    }

    return LocationBloc._privateConstrucator(
      search: autocompleteSubject.sink,
      result: result,
      location: location(),
      address: address(),
    );
  }

  const LocationBloc._privateConstrucator({
    required this.search,
    required this.result,
    required this.location,
    required this.address,
  });
}
