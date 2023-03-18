import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';

class RestaurantsPage {
  final String? nextPageToken;
  final String? errorMessage;
  final List<GoogleRestaurant> restaurants;

  RestaurantsPage({
    this.nextPageToken,
    this.errorMessage,
    required this.restaurants,
  });

  factory RestaurantsPage.fromJson(Map<String, dynamic> json) {
    return RestaurantsPage(
      nextPageToken: json['next_page_token'],
      restaurants: json['results'],
    );
  }

  static Map<String, String>? getErrorMessage(String? errorType) {
    if (errorType == null) return null;
    final String errorType$ = errorType.toLowerCase();
    return _errorMessages[errorType$];
  }

  static final Map<String, Map<String, String>> _errorMessages =
      <String, Map<String, String>>{
    'zero results': {
      'title': 'No restaurants :(',
      'solution': 'Try to change your current addres.',
    },
  };
}
