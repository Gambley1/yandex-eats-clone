// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:shared/shared.dart' hide Address;
import 'package:shimmer/shimmer.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';
import 'package:yandex_food_delivery_clone/src/payments/payments.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/restaurants.dart';

class OrderProgressBottomPage extends StatelessWidget {
  const OrderProgressBottomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderProgressCubit(),
      child: const OrderProgressBottomView(),
    );
  }
}

class OrderProgressBottomView extends StatefulWidget {
  const OrderProgressBottomView({super.key});

  @override
  State<OrderProgressBottomView> createState() =>
      _OrderProgressBottomViewState();
}

class _OrderProgressBottomViewState extends State<OrderProgressBottomView> {
  @override
  void initState() {
    super.initState();
    _processOrder();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double generateRandomDelay() {
    final random = Random();
    return 3 + random.nextDouble() * 5;
  }

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  Future<void> _processOrder() async {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      context.read<OrderProgressCubit>().addCount(_stopwatch.elapsed);
    });

    void success() {
      context.goNamed(AppRoutes.restaurants.name);
    }

    await Future<void>.delayed(
      Duration(seconds: generateRandomDelay().toInt()),
    );

    try {
      await handlePayProcess().whenComplete(() {
        context.read<CartBloc>().add(
              CartPlaceOrderRequested(
                orderAddress: context.read<LocationBloc>().state.address,
              ),
            );
      });
      _stopwatch.stop();
      _timer?.cancel();
      context
        ..pop()
        ..pop();
      success();
    } catch (error) {
      _stopwatch.stop();
      _timer?.cancel();
      context.showSnackBar(
        'Something went wrong!',
        solution: 'Try again.',
        snackBarAction: SnackBarAction(
          label: 'Reload',
          onPressed: () => context
              .read<RestaurantsBloc>()
              .add(const RestaurantsRefreshRequested()),
        ),
        duration: const Duration(seconds: 6),
      );
    }
  }

  Future<void> handlePayProcess() async {
    final selectedCard = context.read<SelectedCardCubit>().state.selectedCard;
    final card = CardDetails(
      number: selectedCard.number,
      cvc: selectedCard.cvv,
      expirationMonth: int.parse(selectedCard.expiryDate.split('/').first),
      expirationYear: int.parse(selectedCard.expiryDate.split('/').last),
    );
    await Stripe.instance.dangerouslyUpdateCardDetails(card);

    final user = context.read<AppBloc>().state.user;
    final address = context.read<LocationBloc>().state.address;

    try {
      // 1. Gather customer billing information (ex. email)

      final billingDetails = BillingDetails(
        email: user.email,
        name: user.name,
        address: Address(
          city: 'Almaty',
          country:
              WidgetsBinding.instance.platformDispatcher.locale.countryCode ??
                  address.country?.getCountryCode(),
          line1: address.street,
          line2: '',
          postalCode: '',
          state: '',
        ),
      );

      // 2. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );

      final cart = context.read<CartBloc>().state;
      final orderDeliveryFee = cart.orderDeliveryFee == 0
          ? null
          : cart.orderDeliveryFee.toStringAsFixed(2).replaceAll('.', '');

      // 3. call API to create PaymentIntent
      final paymentIntentResult = await context
          .read<PaymentsRepository>()
          .callNoWebhookPayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'usd',
        items: [
          orderDeliveryFee ?? '',
          ...cart.items.map(
            (item) => (item.priceWithDiscount * cart.quantity(item))
                .toStringAsFixed(2)
                .replaceAll('.', ''),
          ),
        ],
      );

      if (paymentIntentResult['error'] != null) {
        // Error during creating or confirming Intent
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${paymentIntentResult['error']}')),
        );
        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == null) {
        // Payment succeded

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success! The payment was confirmed successfully!'),
          ),
        );
        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == true) {
        // 4. if payment requires action calling handleNextAction
        final paymentIntent = await Stripe.instance
            .handleNextAction(paymentIntentResult['clientSecret'] as String);

        if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
          // 5. Call API to confirm intent
          await confirmIntent(paymentIntent.id);
        } else {
          // Payment failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${paymentIntentResult['error']}'),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  Future<void> confirmIntent(String paymentIntentId) async {
    final result = await context
        .read<PaymentsRepository>()
        .callNoWebhookPayEndpointIntentId(
          paymentIntentId: paymentIntentId,
        );
    if (result['error'] != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${result['error']}')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Success!: The payment was confirmed successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      content: BlocBuilder<OrderProgressCubit, String>(
        builder: (context, progress) {
          // final progressText = (progress * 10).round();

          return PopScope(
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
                          progress,
                          style: context.headlineSmall
                              ?.copyWith(fontWeight: AppFontWeight.regular),
                        ),
                      ],
                    ),
                  ),
                  // LinearProgressIndicator(value: progress),
                  const SmoothProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SlowdownCurve extends Curve {
  const SlowdownCurve(this.slowdownStart);

  final double slowdownStart;

  @override
  double transform(double t) {
    return t < slowdownStart
        ? t
        : slowdownStart + (t - slowdownStart) * slowdownStart;
  }
}

class SmoothProgressIndicator extends StatefulWidget {
  const SmoothProgressIndicator({super.key});

  @override
  State<SmoothProgressIndicator> createState() =>
      _SmoothProgressIndicatorState();
}

class _SmoothProgressIndicatorState extends State<SmoothProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 50,
      ),
    );

    _animation = Tween<double>(begin: 0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const SlowdownCurve(0.3),
      ),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return LinearProgressIndicator(
          value: _animation.value,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        );
      },
    );
  }
}
