import 'package:flutter/material.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_bloc_test.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_result.dart';

class BadgeNotifier extends ValueNotifier<bool> {
  factory BadgeNotifier() => _instance;

  BadgeNotifier._privateConstructor(super.value) {
    _checkPendingOrders();
  }
  static final BadgeNotifier _instance =
      BadgeNotifier._privateConstructor(false);

  final _ordersBloc = OrdersBlocTest();

  void _checkPendingOrders() {
    _ordersBloc.orders.listen((event) {
      if (event is OrdersWithListResult) {
        final pendingOrders =
            event.orders.where((element) => element.status == 'Pending');
        if (pendingOrders.isNotEmpty) {
          value = true;
        } else {
          value = false;
        }
      }
    });
  }
}
