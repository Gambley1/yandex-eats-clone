// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:papa_burger/isolates.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/pages/cart/state/cart_bloc.dart';
import 'package:papa_burger/src/views/pages/cart/state/order_bloc.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_bloc_test.dart';
import 'package:papa_burger/src/views/pages/main/state/location_bloc.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';
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
  final _ordersBloc = OrdersBlocTest();
  final _faker = Faker();
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
        Future<void>.delayed(
          const Duration(seconds: 1),
          () async {
            try {
              context
                ..pop()
                ..pop();
              final dateFormat = DateFormat('dd MMMM HH:mm', 'en_US');
              final deliveryDateFormat = DateFormat('HH:mm', 'en_US');
              final id = _faker.randomGenerator.integer(100000).toString();
              final now = DateTime.now();
              final date = dateFormat.format(now);
              final cart = CartBloc().value;
              final restaurantPlaceId = cart.restaurantPlaceId;
              final restaurant =
                  _ordersBloc.getOrderDetailsRestaurant(restaurantPlaceId);
              final deliveryTime = restaurant.deliveryTime;
              final deliverByWalk = deliveryTime < 8;
              final deliveryTime$ = (deliverByWalk ? 15 : deliveryTime) + 10;
              final deliveryDate = now.add(Duration(minutes: deliveryTime$));
              final formattedDeliveryDate =
                  deliveryDateFormat.format(deliveryDate);
              final restaurantName = restaurant.name;
              final orderAddress = LocationNotifier().value;
              final totalOrderSum = cart.totalRound();
              final orderDeliveryFee = cart.getDeliveryFee.toString();

              final message = await _ordersBloc.createOrder(
                id,
                date,
                restaurantPlaceId,
                restaurantName,
                orderAddress,
                totalOrderSum,
                orderDeliveryFee,
                formattedDeliveryDate,
              );
              await CartBloc().removeAllItems().then((_) {
                CartBloc().removePlaceIdInCacheAndCart();
                context.goToHome();
                logI('Message: $message');
                context.showSnackBar(message);
              });
            } catch (e) {
              if (e is NoSuchRestaurantException) {
                context.showSnackBar(
                  e.message,
                  solution: 'Reload restaurants and try again.',
                  snackBarAction: const SnackBarAction(
                    label: 'RELOAD',
                    onPressed: useRestaurantsIsolate,
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
          return PopScope(
            canPop: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 240, top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 6, 24, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer(
                              period: const Duration(milliseconds: 1000),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFEBEBEB),
                                  AppColors.black,
                                  Color(0xFFEBEBEB),
                                ],
                                stops: [0.2, 0.4, 0.8],
                              ),
                              child: Text(
                                'Payment',
                                style: context.headlineSmall?.copyWith(
                                  fontWeight: AppFontWeight.regular,
                                ),
                              ),
                            ),
                            Text(
                              'Waiting your bank to approve',
                              style: context.bodyMedium
                                  ?.apply(color: AppColors.grey),
                            ),
                          ],
                        ),
                        Text(
                          '00:$progressText',
                          style: context.headlineSmall
                              ?.copyWith(fontWeight: AppFontWeight.regular),
                        ),
                      ],
                    ),
                  ),
                  LinearProgressIndicator(value: progressValue),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
