import 'package:papa_burger/src/restaurant.dart';

class UrlBuilder {
  const UrlBuilder({
    String? baseUrl,
  }) : _baseUrl = baseUrl ?? 'https://reqres.in/api';

  final String _baseUrl;

  final String _baseDummyUrl = 'http://127.0.0.1:5500/apis/restaurants.json';
  final String autoCompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  final String apiKey = googleApiKey;

  String dummyStringOfRestaurants() {
    return _baseDummyUrl;
  }

  String buildLogInUrl() {
    return '$_baseUrl/login';
  }

  String buildSingOutUrl() {
    return '$_baseUrl/users/2';
  }

  String buildMapAutoCompleteUrl(
      // {required double lat, required double long, required double radius, required String query}
      {required String query}) {
    return '$autoCompleteUrl?input=$query&types=geocode&key=$apiKey';
    // return '$autoCompleteUrl?input=$query&types=establishment&location=$lat,$long&radius=$radius&types=geocode&key=$apiKey';
  }
}
