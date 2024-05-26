import 'dart:async';

import 'package:flutter/material.dart';
import 'package:papa_burger/src/orders/bloc/orders_bloc_test.dart';
import 'package:papa_burger/src/orders/bloc/orders_result.dart';
import 'package:shared/shared.dart';

class BadgeNotifier extends ValueNotifier<bool> {
  factory BadgeNotifier() => _instance;

  BadgeNotifier._(super.value) {
    _listenPendingOrders();
  }
  static final BadgeNotifier _instance = BadgeNotifier._(false);

  final _ordersBloc = OrdersBlocTest();

  StreamSubscription<OrdersResult>? _ordersSubscription;

  void _listenPendingOrders() {
    _ordersSubscription ??= _ordersBloc.orders.listen((event) {
      if (event is OrdersWithListResult) {
        final pendingOrders =
            event.orders.where((e) => e.status == OrderStatus.pedning);
        value = pendingOrders.isNotEmpty;
      }
    });
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}
