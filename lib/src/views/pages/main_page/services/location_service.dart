import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart';

final LocationApi locationApi = LocationApi();

@immutable
class LocationService {
  static final _instance = LocationService._privateConstrucator();

  factory LocationService() => _instance;

  LocationService get instance => _instance;

  LocationService._privateConstrucator();

  final LocationBloc locationBloc = LocationBloc(locationApi: locationApi);

  Stream<LocationResult?> get streamLocResult => locationBloc.result;
  Sink<String> get locSearch => locationBloc.search;
}
