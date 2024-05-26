// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:papa_burger_server/api.dart' as server;
import 'package:shared/shared.dart';

enum OrderStatus {
  pedning,
  canceled,
  completed;

  static OrderStatus fromJson(String jsonString) =>
      OrderStatus.values.firstWhere((e) => e.name == jsonString);
  String toJson() => OrderStatus.values.firstWhere((e) => e == this).name;
}

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
    required this.totalOrderSum,
    required this.orderDeliveryFee,
  });

  /// Associated order details id identifier
  final String id;

  /// Associated order details status
  final OrderStatus status;

  /// Associated order details date
  final String date;

  /// Associated order details restaurant place id
  final String restaurantPlaceId;

  /// Associated order details restaurant name
  final String restaurantName;

  /// Associated order details order address
  final String orderAddress;

  /// Associated order details order menu items
  final List<OrderMenuItem> orderMenuItems;

  /// Associated order details total order sum
  final double totalOrderSum;

  /// Associated order details order delivery fee
  final double orderDeliveryFee;

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'date': date,
        'restaurant_place_id': restaurantPlaceId,
        'restaurant_name': restaurantName,
        'order_address': orderAddress,
        'order_menu_items': orderMenuItems.map((x) => x.toJson()).toList(),
        'total_order_sum': totalOrderSum,
        'order_delivery_fee': orderDeliveryFee,
      };

  factory OrderDetails.fromJson(Map<String, dynamic> map) {
    return OrderDetails(
      id: map['id'] as String,
      status: OrderStatus.fromJson(map['status'] as String),
      date: map['date'] as String,
      restaurantPlaceId: map['restaurant_place_id'] as String,
      restaurantName: map['restaurant_name'] as String,
      orderAddress: map['order_address'] as String,
      orderMenuItems: List<OrderMenuItem>.from(
        (map['order_menu_items'] as List).map<OrderMenuItem>(
          (x) => OrderMenuItem.fromJson(x as Map<String, dynamic>),
        ),
      ),
      totalOrderSum: map['total_order_sum'] as double,
      orderDeliveryFee: map['order_delivery_fee'] as double,
    );
  }

  factory OrderDetails.fromDb(server.OrderDetails orderDetails) {
    return OrderDetails(
      id: orderDetails.id,
      status: OrderStatus.fromJson(orderDetails.status),
      date: orderDetails.date,
      restaurantPlaceId: orderDetails.restaurantPlaceId,
      restaurantName: orderDetails.restaurantName,
      orderAddress: orderDetails.orderAddress,
      orderMenuItems: orderDetails.orderMenuItems
          .map<OrderMenuItem>(OrderMenuItem.fromDb)
          .toList(),
      totalOrderSum: orderDetails.totalOrderSum,
      orderDeliveryFee: orderDetails.orderDeliveryFee,
    );
  }
}
