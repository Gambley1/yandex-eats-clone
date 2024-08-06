import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_delivery_clone/src/orders/orders.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(const OrdersFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Orders'),
        titleTextStyle: context.headlineSmall,
      ),
      body: RefreshIndicator(
        backgroundColor: AppColors.white,
        color: AppColors.black,
        strokeWidth: 3,
        onRefresh: () async =>
            context.read<OrdersBloc>().add(const OrdersRefreshRequested()),
        child: const CustomScrollView(
          slivers: [
            OrdersListView(),
          ],
        ),
      ),
    );
  }
}
