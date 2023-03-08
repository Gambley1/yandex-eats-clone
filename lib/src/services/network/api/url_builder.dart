import 'package:papa_burger/src/restaurant.dart';

class UrlBuilder {
  UrlBuilder({
    String? baseUrl,
  }) : _baseUrl = baseUrl ?? 'https://reqres.in/api';

  final String _baseUrl;

  static const String _baseDummyUrl =
      'http://127.0.0.1:5500/apis/restaurants.json';
  static const String autoCompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String placeDetailsUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';
  static const String apiKey = googleApiKey;

  String dummyStringOfRestaurants() {
    return _baseDummyUrl;
  }

  String buildLogInUrl() {
    return '$_baseUrl/login';
  }

  String buildSingOutUrl() {
    return '$_baseUrl/users/2';
  }

  String buildMapAutoCompleteUrl({required String query}) {
    return '$autoCompleteUrl?input=$query&types=geocode&key=$apiKey';
  }

  String buildGetPlaceDetailsUrl({required String placeId}) {
    return '$placeDetailsUrl?place_id=$placeId&key=$apiKey';
  }
}
