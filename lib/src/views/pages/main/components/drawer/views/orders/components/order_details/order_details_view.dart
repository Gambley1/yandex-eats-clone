import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/components/header_app_bar.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/components/order_details/components/order_details_action_button.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/components/order_details/components/order_menu_item_tile.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_bloc_test.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_result.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';
import 'package:shared/shared.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({
    required this.orderId,
    this.scaffoldMessengerKey,
    super.key,
  });

  final OrderId orderId;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  final OrdersBlocTest _ordersBloc = OrdersBlocTest();
  String? _status;
  Restaurant? _restaurant;
  OrderId? _orderId;

  @override
  void initState() {
    super.initState();
    _ordersBloc.fetchOrderDetails(widget.orderId);
    _ordersBloc.getOrderDetails(widget.orderId).then((orderDetails) {
      setState(() {
        _status = orderDetails.status;
        _restaurant = _ordersBloc
            .getOrderDetailsRestaurant(orderDetails.restaurantPlaceId);
        _orderId = orderDetails.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: CustomScrollView(
        slivers: [
          HeaderAppBar(text: _status ?? ''),
          StreamBuilder<OrdersResult>(
            stream: _ordersBloc.orderDetails,
            builder: (context, snapshot) {
              void tryAgain() =>
                  _ordersBloc.tryGetOrderDetailsAgain(_orderId ?? '');
              final state = snapshot.data;
              if (state is OrdersError) {
                final error = state.error;
                if (error is OrderDetailsNotFoundException) {
                  return const OrderDetailsNotFoundError();
                }
                return OrderDetailsGenericError(
                  tryAgain: tryAgain,
                );
              }
              if (state is OrdersLoading) {
                return const OrderDetailsLoading();
              }
              if (state is OrdersWithNoResult) {
                return const OrderDetailsEmpty();
              }
              if (state is OrdersWithDetailsResult) {
                Future<String> deleteOrder(OrderId orderId) =>
                    _ordersBloc.deleteOrder(orderId);
                void refreshOrders() => _ordersBloc.tryGetOrdersAgain;
                final orderDetails = state.orderDetails;
                return OrderDetailsWithDetails(
                  deleteOrder: deleteOrder,
                  refreshOrders: () => refreshOrders,
                  orderDetails: orderDetails,
                  scaffoldMessengerKey: widget.scaffoldMessengerKey,
                  restaurant: _restaurant ?? const Restaurant.empty(),
                );
              }
              return const OrderDetailsLoading();
            },
          ),
        ],
      ),
    );
  }
}

class OrderDetailsWithDetails extends StatelessWidget {
  const OrderDetailsWithDetails({
    required this.orderDetails,
    required this.restaurant,
    required this.deleteOrder,
    required this.refreshOrders,
    this.scaffoldMessengerKey,
    super.key,
  });

  final OrderDetails orderDetails;
  final Restaurant restaurant;
  final Future<String> Function(OrderId) deleteOrder;
  final void Function() refreshOrders;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  @override
  Widget build(BuildContext context) {
    final orderId = orderDetails.id;
    final totalSum = orderDetails.totalOrderSum.round().currencyFormat();
    final date = orderDetails.date;
    final restaurantName = orderDetails.restaurantName;
    final orderMenuItems = orderDetails.orderMenuItems;
    final deliveryFee = orderDetails.orderDeliveryFee.round().currencyFormat();
    final orderAddress = orderDetails.orderAddress;
    
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
            ),
            title: LimitedBox(
              maxWidth: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order № $orderId',
                    maxLines: 1,
                    style: context.bodyLarge,
                  ),
                ],
              ),
            ),
            subtitle: Text(
              date,
              style: context.bodySmall,
            ),
            trailing: Text(
              totalSum,
              style: context.titleLarge
                  ?.copyWith(fontWeight: AppFontWeight.semiBold),
            ),
          ),
          ListTile(
            onTap: () => context.goToMenu(context, restaurant),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
            ),
            title: Text(
              'From restaurant',
              style: context.bodyMedium
                  ?.apply(color: AppColors.grey.withOpacity(.6)),
            ),
            subtitle: Text(
              restaurantName,
              style: context.bodyLarge,
            ),
            trailing: const Text('Go to>'),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 6,
              bottom: 8,
              left: kDefaultHorizontalPadding,
              right: kDefaultHorizontalPadding,
            ),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OrderDetailsActionButton(
                text: 'Hide',
                icon: FontAwesomeIcons.eyeSlash,
                onTap: () {
                  deleteOrder(orderId).then((value) {
                    context
                      ..pop()
                      ..pop();
                    scaffoldMessengerKey?.currentState
                      ?..clearSnackBars()
                      ..showSnackBar(
                        customSnackBar(value),
                      );
                  });
                },
              ),
              OrderDetailsActionButton(
                text: 'Support',
                icon: Icons.message,
                onTap: () {},
              ),
              OrderDetailsActionButton(
                text: 'Repeat',
                icon: Icons.refresh,
                size: 32,
                onTap: () {},
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  bottom: 6,
                  left: kDefaultHorizontalPadding,
                  right: kDefaultHorizontalPadding,
                ),
                child: Text(
                  'Order list',
                  style: context.headlineSmall,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 8,
                  left: kDefaultHorizontalPadding,
                  right: kDefaultHorizontalPadding,
                ),
                child: Divider(
                  color: Colors.grey,
                  height: 1,
                ),
              ),
              ...ListTile.divideTiles(
                context: context,
                tiles: orderMenuItems.map(
                  (orderMenuItem) =>
                      OrderMenuItemTile(orderMenuItem: orderMenuItem),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Delivery and payment',
                      style: context.headlineSmall,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Cost of goods',
                      style: context.titleLarge,
                    ),
                    trailing: Text(totalSum),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Delivery fee',
                      style: context.titleLarge,
                    ),
                    subtitle: Text(
                      orderAddress,
                      style: context.bodyMedium
                          ?.apply(color: AppColors.grey.withOpacity(.6)),
                    ),
                    trailing: Text(deliveryFee),
                  ),
                ],
              ).toList(),
            ),
          ),
          ListTile(
            title: Text(
              'Overall',
              style:
                  context.titleLarge?.copyWith(fontWeight: AppFontWeight.bold),
            ),
            trailing: Text(
              totalSum,
              style: context.titleLarge
                  ?.copyWith(fontWeight: AppFontWeight.semiBold),
            ),
          ),
          const SizedBox(
            height: 68,
          ),
        ],
      ),
    );
  }
}

class OrderDetailsEmpty extends StatelessWidget {
  const OrderDetailsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class OrderDetailsGenericError extends StatelessWidget {
  const OrderDetailsGenericError({
    required this.tryAgain,
    super.key,
  });

  final void Function() tryAgain;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Something went wrong.',
            style: context.headlineMedium
                ?.copyWith(fontWeight: AppFontWeight.semiBold),
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius + 6),
                ),
              ),
              backgroundColor: const WidgetStatePropertyAll(AppColors.indigo),
            ),
            onPressed: tryAgain,
            child: Text(
              'Try again.',
              style: context.bodyLarge?.apply(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsNotFoundError extends StatelessWidget {
  const OrderDetailsNotFoundError({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Order details are not found.',
            style: context.headlineMedium
                ?.copyWith(fontWeight: AppFontWeight.semiBold),
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius + 6),
                ),
              ),
              backgroundColor: const WidgetStatePropertyAll(AppColors.indigo),
            ),
            onPressed: () => context.pop(),
            child: Text(
              '<- Back',
              style: context.bodyLarge?.apply(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsLoading extends StatelessWidget {
  const OrderDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: CustomCircularIndicator(
        color: Colors.black,
      ),
    );
  }
}
