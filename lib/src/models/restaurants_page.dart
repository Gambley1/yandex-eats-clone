import 'package:papa_burger/src/models/restaurant.dart';

class RestaurantsPage {
  RestaurantsPage({
    required this.restaurants,
    this.nextPageToken,
    this.errorMessage,
    this.status,
    this.hasMore,
  });

  factory RestaurantsPage.fromJson(Map<String, dynamic> json) {
    return RestaurantsPage(
      nextPageToken: json['next_page_token'] as String,
      restaurants: List<Restaurant>.from(['results']),
    );
  }
  final String? nextPageToken;
  final String? errorMessage;
  final String? status;
  final bool? hasMore;
  final List<Restaurant> restaurants;

  static Message? getErrorMessage(String? errorType) {
    if (errorType == null) return null;
    final errorType$ = errorType.toLowerCase();
    return _errorMessages[errorType$];
  }

  static final Map<String, Message> _errorMessages = <String, Message>{
    'zero results': Message(
      title: 'No restaurants :(',
      solution: 'Try to change your current address.',
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
  Message({
    required this.title,
    required this.solution,
  });
  final String title;
  final String solution;
}
