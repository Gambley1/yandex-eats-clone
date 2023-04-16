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

  static Message? getErrorMessage(String? errorType) {
    if (errorType == null) return null;
    final String errorType$ = errorType.toLowerCase();
    return _errorMessages[errorType$];
  }

  static final Map<String, Message> _errorMessages = <String, Message>{
    'zero results': Message(
      title: 'No restaurants :(',
      solution: 'Try to change your current addres.',
    ),
    'unknown error': Message(
      title: 'Something went wrong!',
      solution: 'Try to check wifi connection or change your address.',
    ),
    'connection timeout': Message(
      title: 'API Call is out of time!',
      solution: 'Check your wifi connection.',
    ),
    'request denied': Message(
      title: 'Request denied 😥',
      solution: 'Need to pay for bill to continue using API.',
    ),
  };
}

class Message {
  final String title;
  final String solution;

  Message({
    required this.title,
    required this.solution,
  });
}
