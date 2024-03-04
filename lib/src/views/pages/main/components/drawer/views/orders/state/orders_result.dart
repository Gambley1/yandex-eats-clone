import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/order_details.dart';

@immutable
abstract class OrdersResult {
  const OrdersResult();
}

@immutable
class OrdersError extends OrdersResult {
  const OrdersError(this.error);

  final Object error;
}

@immutable
class OrdersLoading extends OrdersResult {
  const OrdersLoading();
}

@immutable
class OrdersWithListResult extends OrdersResult {
  const OrdersWithListResult(this.orders);

  final List<OrderDetails> orders;
}

@immutable
class OrdersWithDetailsResult extends OrdersResult {
  const OrdersWithDetailsResult(this.orderDetails);

  final OrderDetails orderDetails;
}

@immutable
class OrdersWithNoResult extends OrdersResult {
  const OrdersWithNoResult();
}

@immutable
class OrdersWithNoInternet extends OrdersResult {
  const OrdersWithNoInternet();
}
