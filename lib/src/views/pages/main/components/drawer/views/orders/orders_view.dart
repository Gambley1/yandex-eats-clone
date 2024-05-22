import 'package:flutter/material.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/components/header_app_bar.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/components/orders_list_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_bloc_test.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersBloc = OrdersBlocTest();
    final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: AppScaffold(
        key: scaffoldKey,
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.black,
          strokeWidth: 3,
          onRefresh: () async => ordersBloc.tryGetOrdersAgain,
          child: CustomScrollView(
            slivers: [
              const HeaderAppBar(text: 'Orders'),
              OrdersListView(
                ordersBloc: ordersBloc,
                scaffoldMessengerKey: scaffoldMessengerKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
