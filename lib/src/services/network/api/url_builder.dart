import 'package:papa_burger/src/restaurant.dart' show googleApiKey, logger;

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
  static const String geocedeUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';
  static const String nearbyPlacesUlr =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
  static const String restaurantDetailsUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';
  static const String restaurantPhototUrl =
      'https://maps.googleapis.com/maps/api/place/photo';
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

  String buildGeocoderUrl({required double lat, required double lng}) {
    return '$geocedeUrl?latlng=$lat,$lng&key=$apiKey';
  }

  String buildNearbyPlacesUrl({
    required double lat,
    required double lng,
    required int radius,
    required String? nextPageToken,
    required bool forMainPage,
    String type = 'restaurant',
  }) {
    logger.w('Next Page Token $nextPageToken');
    final pageToken = nextPageToken == null ? '' : 'pagetoken=$nextPageToken';
    final forRestaurantsPageUlr =
        '$nearbyPlacesUlr?types=$type&rankby=distance&location=$lat,$lng&$pageToken&key=$apiKey';
    final forMainPageUrl =
        '$nearbyPlacesUlr?types=$type&rankby=distance&opennow=true&location=$lat,$lng&$pageToken&key=$apiKey';

    return forMainPage ? forMainPageUrl : forRestaurantsPageUlr;
  }

  String buildRestaurantDetailsUrl({
    required String placeId,
  }) {
    return '$restaurantDetailsUrl?place_id=$placeId&key=$apiKey';
  }

  String buildRestaurantPhotoUlr({
    required String photoReference,
    required int maxwidth,
  }) {
    return '$restaurantPhototUrl?maxwidth=$maxwidth&photo_reference=$photoReference&key=$apiKey';
  }
}
