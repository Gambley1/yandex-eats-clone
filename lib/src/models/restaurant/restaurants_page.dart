import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';

class RestaurantsPage {
  final String? nextPageToken;
  final List<GoogleRestaurant> restaurants;

  RestaurantsPage({
    required this.nextPageToken,
    required this.restaurants,
  });

  factory RestaurantsPage.fromJson(Map<String, dynamic> json) {
    return RestaurantsPage(
      nextPageToken: json['next_page_token'],
      restaurants: json['results'],
    );
  }
}
