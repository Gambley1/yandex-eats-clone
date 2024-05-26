import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/orders/bloc/orders_bloc_test.dart';
import 'package:papa_burger/src/orders/widgets/orders_list_view.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersBloc = OrdersBlocTest();

    return AppScaffold(
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.black,
        strokeWidth: 3,
        onRefresh: () async => ordersBloc.tryGetOrdersAgain,
        child: CustomScrollView(
          slivers: [
            const HeaderAppBar(text: 'Orders'),
            OrdersListView(ordersBloc: ordersBloc),
          ],
        ),
      ),
    );
  }
}
