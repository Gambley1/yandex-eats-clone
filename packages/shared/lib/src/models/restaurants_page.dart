import 'package:yandex_food_api/client.dart';

class RestaurantsPage {
  const RestaurantsPage({
    required this.restaurants,
    this.hasMore = true,
  });

  final bool hasMore;
  final List<Restaurant> restaurants;
}
