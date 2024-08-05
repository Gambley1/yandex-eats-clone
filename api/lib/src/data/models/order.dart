// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:yandex_food_api/api.dart';

/// {@template order}
/// A class which represents a single order.
/// {@endtemplate}
class Order {
  /// {@macro order_details}
  const Order({
    required this.id,
    required this.status,
    required this.date,
    required this.restaurantPlaceId,
    required this.restaurantName,
    required this.address,
    required this.items,
    required this.totalOrderSum,
    required this.deliveryFee,
  });

  /// Associated order id
  final String id;

  /// Associated order status
  final OrderStatus status;

  /// Associated order date
  final String date;

  /// Associated order restaurant place id
  final String restaurantPlaceId;

  /// Associated order restaurant name
  final String restaurantName;

  /// Associated order order address
  final String address;

  /// Associated order order menu items
  final List<OrderMenuItem> items;

  /// Associated order total order sum
  final double totalOrderSum;

  /// Associated order order deilvery fee
  final double deliveryFee;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'date': date,
      'restaurant_place_id': restaurantPlaceId,
      'restaurant_name': restaurantName,
      'address': address,
      'menu_items': items.map((x) => x.toJson()).toList(),
      'total_order_sum': totalOrderSum,
      'delivery_fee': deliveryFee,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      status: OrderStatus.fromJson(json['status'] as String),
      date: json['date'] as String,
      restaurantPlaceId: json['restaurant_place_id'] as String,
      restaurantName: json['restaurant_name'] as String,
      address: json['address'] as String,
      items: List<OrderMenuItem>.from(
        (json['menu_items'] as List).map<OrderMenuItem>(
          (x) => OrderMenuItem.fromJson(x as Map<String, dynamic>),
        ),
      ),
      totalOrderSum: json['total_order_sum'] as double,
      deliveryFee: json['delivery_fee'] as double,
    );
  }

  factory Order.fromView(DborderDetailsView order) {
    return Order(
      id: order.id,
      status: OrderStatus.fromJson(order.status),
      date: order.date,
      restaurantPlaceId: order.restaurantPlaceId,
      restaurantName: order.restaurantName,
      address: order.orderAddress,
      items: order.orderMenuItems.map(OrderMenuItem.fromView).toList(),
      totalOrderSum: order.totalOrderSum,
      deliveryFee: order.orderDeliveryFee,
    );
  }
}
