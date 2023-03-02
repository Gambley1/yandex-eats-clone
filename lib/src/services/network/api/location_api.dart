import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:geolocator/geolocator.dart';
import 'package:papa_burger/src/models/auto_complete/auto_complete.dart';
import 'package:papa_burger/src/restaurant.dart';

@immutable
class LocationApi {
  LocationApi({UrlBuilder? urlBuilder, Dio? dio})
      : _urlBuilder = urlBuilder ?? const UrlBuilder(),
        _dio = dio ?? Dio();

  final UrlBuilder _urlBuilder;
  final Dio _dio;

  final int _time = 15;
  final bool _forceAndroidLocationManager = true;
  final LocationAccuracy _desiredAccuracy = LocationAccuracy.high;
  late final Duration _timeLimit =Duration(seconds: _time);

  Future<Position> determineCurrentPosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission has been denied');
      }
    }
    logger.w('DETERMING CURRENT POSITION');
    return getCurrentPosition();
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: _desiredAccuracy,
      forceAndroidLocationManager: _forceAndroidLocationManager,
      timeLimit: _timeLimit,
    );
  }

  Future<List<AutoComplete>> getAutoComplete(
      // {required double lat,
      // required double long,
      // required double radius,
      // required String query}
      {required String query}) async {
    final url = _urlBuilder.buildMapAutoCompleteUrl(query: query);
    try {
      final response = await _dio.get(url);
      final status = response.data['status'];
      if (status == 'ZERO_RESULTS') {
        logger.w(
            'Indicating that the search was successful but returned no results.');
        return [];
      }
      if (status == 'INVALID_REQUEST') {
        logger.w(
            'Indicating the API request was malformed, generally due to the missing input parameter. ${status.toString()}');
        return [];
      }
      if (status == 'OVER_QUERY_LIMIT') {
        logger.w(
            'The monthly \$200 credit, or a self-imposed usage cap, has been exceeded. ${status.toString()}');
        return [];
      }
      if (status == 'REQUEST_DENIED') {
        logger.w('The request is missing an API key. ${status.toString()}');
        return [];
      }
      if (status == 'UNKNOWN_ERROR') {
        logger.e('Unknown error. ${status.toString()}');
        return [];
      }
      final predictions = response.data['predictions'] as List;
      logger.w(response.data);
      return predictions
          .map<AutoComplete>((json) => AutoComplete.fromJson(json))
          .toList();
    } on DioError catch (e) {
      logger.e('${e.error}, ${e.response}, ${e.type}, ${e.message}');
      return [];
    }
  }
}
