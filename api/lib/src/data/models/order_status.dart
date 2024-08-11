import 'package:yandex_food_api/api.dart';

enum OrderStatus {
  pending,
  canceled,
  completed;

  static OrderStatus fromJson(String jsonString) =>
      OrderStatus.values.firstWhere((e) => e.name == jsonString.toLowerCase());
  String toJson() =>
      OrderStatus.values.firstWhere((e) => e == this).name.capitalized();
}
