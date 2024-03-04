// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:papa_burger/src/models/order_menu_item.dart';
import 'package:papa_burger_server/api.dart' as server;

/// Order details model
class OrderDetails {
  /// {@macro order_details}
  OrderDetails({
    required this.id,
    required this.status,
    required this.date,
    required this.restaurantPlaceId,
    required this.restaurantName,
    required this.orderAddress,
    required this.orderMenuItems,
    required this.totalOrderSumm,
    required this.orderDeliveryFee,
  });

  /// Assosiate order details id identifier
  final String id;

  /// Assosiated order details status
  final String status;

  /// Assosiated order details date
  final String date;

  /// Assosiated order details restaurant place id
  final String restaurantPlaceId;

  /// Assosiated order details restaurant name
  final String restaurantName;

  /// Assosiated order details order address
  final String orderAddress;

  /// Assosiated order details order menu items
  final List<OrderMenuItem> orderMenuItems;

  /// Assosisated order details total order summ
  final double totalOrderSumm;

  /// Assosiated order details order deilvery fee
  final double orderDeliveryFee;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'date': date,
      'restaurant_place_id': restaurantPlaceId,
      'restaurant_name': restaurantName,
      'order_address': orderAddress,
      'order_menu_items': orderMenuItems.map((x) => x.toMap()).toList(),
      'total_order_summ': totalOrderSumm,
      'order_delivery_fee': orderDeliveryFee,
    };
  }

  factory OrderDetails.fromMap(Map<String, dynamic> map) {
    return OrderDetails(
      id: map['id'] as String,
      status: map['status'] as String,
      date: map['date'] as String,
      restaurantPlaceId: map['restaurant_place_id'] as String,
      restaurantName: map['restaurant_name'] as String,
      orderAddress: map['order_address'] as String,
      orderMenuItems: List<OrderMenuItem>.from(
        (map['order_menu_items'] as List).map<OrderMenuItem>(
          (x) => OrderMenuItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalOrderSumm: map['total_order_summ'] as double,
      orderDeliveryFee: map['order_delivery_fee'] as double,
    );
  }

  factory OrderDetails.fromDB(server.OrderDetails orderDetails) {
    return OrderDetails(
      id: orderDetails.id,
      status: orderDetails.status,
      date: orderDetails.date,
      restaurantPlaceId: orderDetails.restaurantPlaceId,
      restaurantName: orderDetails.restaurantName,
      orderAddress: orderDetails.orderAddress,
      orderMenuItems: orderDetails.orderMenuItems
          .map<OrderMenuItem>(OrderMenuItem.fromDB)
          .toList(),
      totalOrderSumm: orderDetails.totalOrderSumm,
      orderDeliveryFee: orderDetails.orderDeliveryFee,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetails.fromJson(String source) =>
      OrderDetails.fromMap(json.decode(source) as Map<String, dynamic>);
}
