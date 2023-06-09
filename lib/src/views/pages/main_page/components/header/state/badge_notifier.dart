import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:papa_burger/src/models/order/order_details.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/views/pages/main_page/components/drawer/views/orders/state/orders_bloc.dart';
import 'package:papa_burger/src/views/pages/main_page/components/drawer/views/orders/state/orders_result.dart';

class BadgeNotifier extends ValueNotifier<bool> {
  factory BadgeNotifier() => _instance;

  BadgeNotifier._privateConstructor(super.value) {
    _checkPendingOrders();
  }
  static final BadgeNotifier _instance =
      BadgeNotifier._privateConstructor(false);

  final _ordersBloc = OrdersBloc();

  void _checkPendingOrders() {
    _ordersBloc.orders.listen((event) {
      if (event is OrdersWithListResult) {
        final peningOrders =
            event.orders.where((element) => element.status == 'Pending');
        if (peningOrders.isNotEmpty) {
          value = true;
        } else {
          value = false;
        }
      }
    });
  }

  Future<List<OrderDetails>> get _getListOrderDetails async {
    final listOrderDetails = await _ordersBloc.getListOrderDetails();
    return listOrderDetails;
  }
}
