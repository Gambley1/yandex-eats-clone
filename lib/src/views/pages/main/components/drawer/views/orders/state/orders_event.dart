part of 'orders_bloc.dart';

abstract class OrdersEvent {
  const OrdersEvent();
}

class OrdersStarted extends OrdersEvent {
  const OrdersStarted();
}

class OrdersFetched extends OrdersEvent {
  const OrdersFetched();
}

class OrdersCreateOrder extends OrdersEvent {
  const OrdersCreateOrder({
    required this.id,
    required this.date,
    required this.restaurantPlaceId,
    required this.restaurantName,
    required this.orderAddress,
    required this.totalOrderSumm,
    required this.orderDeliveryFee,
  });

  final String id;
  final String date;
  final String restaurantPlaceId;
  final String restaurantName;
  final String orderAddress;
  final String totalOrderSumm;
  final String orderDeliveryFee;
}

class OrdersDeleteOrder extends OrdersEvent {
  const OrdersDeleteOrder({
    required this.orderId,
  });

  final String orderId;
}

class OrdersRefreshed extends OrdersEvent {
  const OrdersRefreshed();
}

class _OrdersChanged extends OrdersEvent {
  const _OrdersChanged();
}
