import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/extensions/extensions.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/components/header_app_bar.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/components/orders_list_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_bloc_test.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class OrdersVieww extends StatelessWidget {
  OrdersVieww({super.key});

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final ordersBloc = OrdersBlocTest();
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: AppScaffold(
        key: _scaffoldKey,
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
                scaffoldMessengerKey: _scaffoldMessengerKey,
              ),
            ],
          ).disalowIndicator(),
        ),
      ),
    );
  }
}
