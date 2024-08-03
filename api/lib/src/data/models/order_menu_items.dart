// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:yandex_food_api/api.dart';

/// Order menu items model
class OrderMenuItem {
  /// {@macro order_menu_items}
  const OrderMenuItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image_url': imageUrl,
    };
  }

  factory OrderMenuItem.fromJson(Map<String, dynamic> map) {
    return OrderMenuItem(
      id: map['id'] as int,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      imageUrl: map['image_url'] as String,
    );
  }

  factory OrderMenuItem.fromView(DborderMenuItemView order) {
    return OrderMenuItem(
      id: order.id,
      name: order.name,
      quantity: order.quantity,
      price: order.price,
      imageUrl: order.imageUrl,
    );
  }
}
