// ignore_for_file: public_member_api_docs, avoid_dynamic_calls

import 'package:dio/dio.dart';
import 'package:env/env.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared/shared.dart';

/// {@template location_exception}
/// Exceptions from location repository.
/// {@endtemplate}
abstract class LocationException implements Exception {
  /// {@macro location_exception}
  const LocationException(this.error);

  /// The error which was caught.
  final Object error;

  @override
  String toString() => 'Location exception error: $error';
}

/// {@template get_current_position_failure}
/// Thrown when fetching current position fails.
/// {@endtemplate}
class GetCurrentPositionFailure extends LocationException {
  /// {@macro get_current_position_failure}
  const GetCurrentPositionFailure(super.error);
}

/// {@template location_permission_denied}
/// Thrown when requesting location permission denied.
/// {@endtemplate}
class LocationPermissionDenied extends LocationException {
  /// {@macro location_permission_denied}
  const LocationPermissionDenied(super.error);
}

/// {@template get_auto_complete_failure}
/// Thrown when fetching auto complete fails.
/// {@endtemplate}
class GetAutoCompleteFailure extends LocationException {
  /// {@macro get_auto_complete_failure}
  const GetAutoCompleteFailure(super.error);
}

/// {@template get_place_details_failure}
/// Thrown when fetching place details fails.
/// {@endtemplate}
class GetPlaceDetailsFailure extends LocationException {
  /// {@macro get_place_details_failure}
  const GetPlaceDetailsFailure(super.error);
}

/// {@template get_formatted_address_failure}
/// Thrown when fetching formatted address fails.
/// {@endtemplate}
class GetFormattedAddressFailure extends LocationException {
  /// {@macro get_formatted_address_failure}
  const GetFormattedAddressFailure(super.error);
}

/// {@template location_repository}
/// A repository that manages user location.
/// {@endtemplate}
class LocationRepository {
  /// {@macro location_repository}
  const LocationRepository({required Dio httpClient})
      : _httpClient = httpClient;

  final Dio _httpClient;

  static const _forceAndroidLocationManager = true;
  static const _desiredAccuracy = LocationAccuracy.high;
  static const _timeLimit = Duration(seconds: 15);

  Future<Position> getCurrentPosition() async {
    try {
      await _requestPermission();

      return Geolocator.getCurrentPosition(
        desiredAccuracy: _desiredAccuracy,
        forceAndroidLocationManager: _forceAndroidLocationManager,
        timeLimit: _timeLimit,
      );
    } on LocationPermissionDenied {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetCurrentPositionFailure(error), stackTrace);
    }
  }

  Future<void> _requestPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationPermissionDenied(
          'Location Permission has been denied',
        );
      }
    }
  }

  Future<List<AutoComplete>> getAutoCompletes({required String input}) async {
    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
      ).replace(
        queryParameters: {
          'input': input,
          'types': 'geocode',
          'key': Env.googleMapsApiKey,
        },
      );
      final response = await _httpClient.getUri<Map<String, dynamic>>(uri);
      final data = response.data;
      final predictions = data!['predictions'] as List;
      return predictions
          .map(
            (e) => AutoComplete.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetAutoCompleteFailure(error), stackTrace);
    }
  }

  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final uri =
          Uri.parse('https://maps.googleapis.com/maps/api/place/details/json')
              .replace(
        queryParameters: {
          'place_id': placeId,
          'key': Env.googleMapsApiKey,
        },
      );
      final response = await _httpClient.getUri<Map<String, dynamic>>(uri);
      final data = response.data;
      final result = data?['result'];
      if (result == null) return null;

      final details = PlaceDetails.fromJson(result as Map<String, dynamic>);
      return details;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetPlaceDetailsFailure(error), stackTrace);
    }
  }

  Future<String> getFormattedAddress(double lat, double lng) async {
    try {
      final uri = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json')
          .replace(
        queryParameters: {
          'latlng': '$lat,$lng',
          'key': Env.googleMapsApiKey,
        },
      );
      final response = await _httpClient.getUri<Map<String, dynamic>>(uri);
      final data = response.data;
      if ((data!['results'] as List).length < 2) {
        throw const GetFormattedAddressFailure('No address found');
      }
      final formattedAddress =
          data['results'][1]['formatted_address'] as String;
      return formattedAddress;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetFormattedAddressFailure(error), stackTrace);
    }
  }
}
