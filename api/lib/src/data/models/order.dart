import 'package:json_annotation/json_annotation.dart';
import 'package:yandex_food_api/api.dart';

part 'order.g.dart';

class OrderStatusJsonConverter implements JsonConverter<OrderStatus, String> {
  const OrderStatusJsonConverter();

  @override
  OrderStatus fromJson(String json) {
    return OrderStatus.fromJson(json);
  }

  @override
  String toJson(OrderStatus object) {
    return object.toJson();
  }
}

/// {@template order}
/// A class which represents a single order.
/// {@endtemplate}
@JsonSerializable()
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

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

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

  /// Associated order id
  final String id;

  /// Associated order status
  @OrderStatusJsonConverter()
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

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
