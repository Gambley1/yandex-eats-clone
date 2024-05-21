import 'package:papa_burger/src/config/config.dart';

class UrlBuilder {
  UrlBuilder();

  static const String autoCompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String placeDetailsUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';
  static const String geocodeUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';
  static const String apiKey = googleApiKey;

  String buildMapAutoCompleteUrl({required String query}) {
    return '$autoCompleteUrl?input=$query&types=geocode&key=$apiKey';
  }

  String buildGetPlaceDetailsUrl({required String placeId}) {
    return '$placeDetailsUrl?place_id=$placeId&key=$apiKey';
  }

  String buildGeocoderUrl({required double lat, required double lng}) {
    return '$geocodeUrl?latlng=$lat,$lng&key=$apiKey';
  }
}
