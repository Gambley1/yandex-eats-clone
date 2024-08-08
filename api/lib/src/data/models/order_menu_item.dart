import 'package:json_annotation/json_annotation.dart';
import 'package:yandex_food_api/api.dart';

part 'order_menu_item.g.dart';

/// Order menu items model
@JsonSerializable()
class OrderMenuItem {
  /// {@macro order_menu_items}
  const OrderMenuItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory OrderMenuItem.fromJson(Map<String, dynamic> map) =>
      _$OrderMenuItemFromJson(map);

  factory OrderMenuItem.fromView(DborderMenuItemView order) {
    return OrderMenuItem(
      id: order.id,
      name: order.name,
      quantity: order.quantity,
      price: order.price,
      imageUrl: order.imageUrl,
    );
  }

  /// Associated order menu items item's id identifier
  final int id;

  /// Associated order menu items item's name
  final String name;

  /// Assosisated order menu items item's quanityt
  final int quantity;

  /// Associated order menu items item's price
  final double price;

  /// Associated order menu items item's image url
  final String imageUrl;

  Map<String, dynamic> toJson() => _$OrderMenuItemToJson(this);
}
