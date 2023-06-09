import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:papa_burger/src/config/extensions/snack_bar_extension.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/views/pages/cart/state/order_bloc.dart';
import 'package:papa_burger/src/views/pages/main_page/components/drawer/views/orders/state/orders_bloc.dart';
import 'package:papa_burger/src/views/widgets/custom_modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class OrderProgressBarModalBottomSheet extends StatefulWidget {
  const OrderProgressBarModalBottomSheet({super.key});

  @override
  State<OrderProgressBarModalBottomSheet> createState() =>
      _OrderProgressBarModalBottomSheetState();
}

class _OrderProgressBarModalBottomSheetState
    extends State<OrderProgressBarModalBottomSheet> {
  final _orderBloc = OrderBloc();
  final _ordersBloc = OrdersBloc();
  final _faker = Faker();
  final _cartBloc = CartBlocTest();
  late StreamSubscription<double> _progressValueSubscription;

  Future<void> updateProgress() async {
    if (mounted && !_orderBloc.isClosed) {
      for (var i = 0.0; i <= 1.0; i += 0.1) {
        await Future<void>.delayed(const Duration(seconds: 1));
        _orderBloc.addCount(i);
      }
    }
  }

  void progressListener(BuildContext context) {
    _progressValueSubscription = _orderBloc.orderProgress.listen((value) {
      if (value >= 0.999999999) {
        Future.delayed(
          const Duration(seconds: 1),
          () async {
            context
              ..pop()
              ..pop();
            try {
              final id = _faker.randomGenerator.integer(100000).toString();
              final now = DateTime.now();
              final date = DateFormat('dd MMMM HH:mm', 'en_US').format(now);
              final cart = _cartBloc.value;
              final restaurantPlaceId = cart.restaurantPlaceId;
              final restaurant =
                  _ordersBloc.getOrderDetailsRestaurant(restaurantPlaceId);
              final restaurantName = restaurant.name;
              final orderAddress = LocationNotifier().value;
              final totalOrderSumm = cart.totalRound();
              final orderDeliveryFee = cart.getDeliveryFee.toString();

              final message = await _ordersBloc.createOrder(
                id,
                date,
                restaurantPlaceId,
                restaurantName,
                orderAddress,
                totalOrderSumm,
                orderDeliveryFee,
              );
              await _cartBloc.removeAllItems().then((_) {
                _cartBloc.removePlaceIdInCacheAndCart();
                context.navigateToMainPage();
                logger.i('Message: $message');
                context.showSnackBar(message);
              });
            } catch (e) {
              if (e is NoSuchRestaurantException) {
                context.showSnackBar(
                  e.message,
                  solution: 'Reload restaurants and try again.',
                  snackBarAction: SnackBarAction(
                    label: 'RELOAD',
                    onPressed: () => MainBloc().refresh(),
                  ),
                  duration: const Duration(seconds: 6),
                );
              } else {
                context.showSnackBar(e.toString());
              }
            }
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    updateProgress();
    progressListener(context);
  }

  @override
  void dispose() {
    _progressValueSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalBottomSheet(
      content: StreamBuilder<double>(
        stream: _orderBloc.orderProgress,
        initialData: _orderBloc.initialCount,
        builder: (context, snapshot) {
          final progressValue = snapshot.requireData;
          final progressText = (progressValue * 10).toStringAsFixed(0);
          return Padding(
            padding: const EdgeInsets.only(bottom: 240, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 6, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer(
                            period: Duration(milliseconds: 1000),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFEBEBEB),
                                Colors.black,
                                Color(0xFFEBEBEB)
                              ],
                              stops: [0.2, 0.4, 0.8],
                            ),
                            child: KText(
                              text: 'Payment',
                              size: 24,
                            ),
                          ),
                          KText(
                            text: 'Waiting your bank to approve',
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      KText(
                        text: '00:$progressText',
                        size: 22,
                      ),
                    ],
                  ),
                ),
                LinearProgressIndicator(
                  value: progressValue,
                ),
              ],
            ),
          );
        },
      ),
    ).onWillPop(() => Future.value(false));
  }
}
