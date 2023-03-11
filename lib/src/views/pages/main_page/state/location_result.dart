import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show AutoComplete;

@immutable
abstract class LocationResult {
  const LocationResult();
}

@immutable
class LocationResultNoResults implements LocationResult {
  const LocationResultNoResults();
}

@immutable
class LocationResultWithResults implements LocationResult {
  final List<AutoComplete> autoCompletes;
  const LocationResultWithResults(this.autoCompletes);
}

@immutable
class LocationResultLoading implements LocationResult {
  const LocationResultLoading();
}

@immutable
class LocationResultError implements LocationResult {
  final Object error;
  const LocationResultError(this.error);
}
