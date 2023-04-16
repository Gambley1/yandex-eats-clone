import 'package:dio/dio.dart' show Dio;
import 'package:flutter/foundation.dart' show immutable;
import 'package:geolocator/geolocator.dart'
    show Geolocator, Position, LocationPermission, LocationAccuracy;
import 'package:papa_burger/src/restaurant.dart'
    show UrlBuilder, logger, AutoComplete, PlaceDetails;

@immutable
class LocationApi {
  LocationApi({
    UrlBuilder? urlBuilder,
    Dio? dio,
  })  : _urlBuilder = urlBuilder ?? UrlBuilder(),
        _dio = dio ?? Dio();

  final UrlBuilder _urlBuilder;
  final Dio _dio;

  static const int _time = 15;
  static const bool _forceAndroidLocationManager = true;
  static const LocationAccuracy _desiredAccuracy = LocationAccuracy.high;
  static const Duration _timeLimit = Duration(seconds: _time);

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
    return _getCurrentPosition();
  }

  Future<Position> _getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: _desiredAccuracy,
      forceAndroidLocationManager: _forceAndroidLocationManager,
      timeLimit: _timeLimit,
    );
  }

  Future<List<AutoComplete>> getAutoComplete({required String query}) async {
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
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }

  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final url = _urlBuilder.buildGetPlaceDetailsUrl(placeId: placeId);

      final response = await _dio.get(url);
      final status = response.data['status'];
      if (status == 'ZERO_RESULTS') {
        logger.w(
            'Indicating that the search was successful but returned no results.');
        return null;
      }
      if (status == 'INVALID_REQUEST') {
        logger.w(
            'Indicating the API request was malformed, generally due to the missing input parameter. ${status.toString()}');
        return null;
      }
      if (status == 'OVER_QUERY_LIMIT') {
        logger.w(
            'The monthly \$200 credit, or a self-imposed usage cap, has been exceeded. ${status.toString()}');
        return null;
      }
      if (status == 'REQUEST_DENIED') {
        logger.w('The request is missing an API key. ${status.toString()}');
        return null;
      }
      if (status == 'UNKNOWN_ERROR') {
        logger.e('Unknown error. ${status.toString()}');
        return null;
      }
      final result = response.data['result'];
      if (result == null) return null;
      final details = PlaceDetails.fromJson(result);
      return details;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  Future<String> getFormattedAddress(double lat, double lng) async {
    final url = _urlBuilder.buildGeocoderUrl(lat: lat, lng: lng);
    try {
      final response = await _dio.get(url);
      final status = response.data['status'];
      if (status == 'ZERO_RESULTS') {
        logger.w(
            'Indicating that the search was successful but returned no results.');
        return '';
      }
      if (status == 'INVALID_REQUEST') {
        logger.w(
            'Indicating the API request was malformed, generally due to the missing input parameter. ${status.toString()}');
        return '';
      }
      if (status == 'OVER_QUERY_LIMIT') {
        logger.w(
            'The monthly \$200 credit, or a self-imposed usage cap, has been exceeded. ${status.toString()}');
        return '';
      }
      if (status == 'REQUEST_DENIED') {
        logger.w('The request is missing an API key. ${status.toString()}');
        return '';
      }
      if (status == 'UNKNOWN_ERROR') {
        logger.e('Unknown error. ${status.toString()}');
        return '';
      }
      final formattedAddress =
          response.data['results'][1]['formatted_address'] as String;
      logger.w(formattedAddress);
      logger.w(lat, lng);
      return formattedAddress;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }
}
