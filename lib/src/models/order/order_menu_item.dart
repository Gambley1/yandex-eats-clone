// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:papa_burger_server/api.dart' as server;

/// Order menu items model
class OrderMenuItem {
  /// {@macro order_menu_items}
  OrderMenuItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  /// Assosiated order menu items item's id identifier
  final int id;

  /// Assosiated order menu items item's name
  final String name;

  /// Assosisated order menu items item's quanityt
  final int quantity;

  /// Assosiated order menu items item's price
  final double price;

  /// Assosiated order menu items item's image url
  final String imageUrl;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image_url': imageUrl,
    };
  }

  factory OrderMenuItem.fromMap(Map<String, dynamic> map) {
    return OrderMenuItem(
      id: map['id'] as int,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      imageUrl: map['image_url'] as String,
    );
  }

  factory OrderMenuItem.fromDB(server.OrderMenuItems order) {
    return OrderMenuItem(
      id: order.id,
      name: order.name,
      quantity: order.quantity,
      price: order.price,
      imageUrl: order.imageUrl,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderMenuItem.fromJson(String source) =>
      OrderMenuItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
