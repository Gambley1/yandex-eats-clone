import 'package:papa_burger/src/restaurant.dart' show Restaurant;

class Mapper {
  static restaurantFromJson(Map<String, dynamic> json) {
    return Restaurant.fromJson(json);
  }
}
