import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';

class RestaurantsPage {
  final String? nextPageToken;
  final String? errorMessage;
  final String? status;
  final bool? hasMore;
  final List<GoogleRestaurant> restaurants;

  RestaurantsPage({
    this.nextPageToken,
    this.errorMessage,
    this.status,
    this.hasMore,
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
    'unknown error': {
      'title': 'Something went wrong!',
      'solution': 'Try to check wifi connection or change your address.',
    },
    'connection timeout': {
      'title': 'API Call is out of time!',
      'solution': 'Check your wifi connection.',
    },
  };
}
