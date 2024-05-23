import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/components/order_card.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_bloc_test.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_result.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';
import 'package:shared/shared.dart';

class OrdersListView extends StatelessWidget {
  OrdersListView({
    required this.ordersBloc,
    this.scaffoldMessengerKey,
    super.key,
  });

  final OrdersBlocTest ordersBloc;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  late final _ordersBloc = ordersBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrdersResult>(
      stream: _ordersBloc.orders,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state is OrdersError) {
          final error = state.error;
          void tryAgain() => _ordersBloc.tryGetOrdersAgain;
          if (error is NetworkException) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.showSnackBar(
                error.message,
                dismissible: false,
                duration: const Duration(days: 1),
                behavior: SnackBarBehavior.floating,
                snackBarAction: SnackBarAction(
                  label: 'REFRESH',
                  textColor: Colors.indigo.shade400,
                  onPressed: () {
                    _ordersBloc.tryGetOrdersAgain;
                  },
                ),
              );
            });
            return const OrdersNetworkError();
          }
          return OrdersGenericError(
            tryAgain: tryAgain,
          );
        }
        if (state is OrdersLoading) {
          return const OrdersLoadingList();
        }
        if (state is OrdersWithNoResult) {
          return const OrdersEmptyList();
        }
        if (state is OrdersWithListResult) {
          final listOrderDetails = state.orders;

          return OrdersWithResultList(
            listOrderDetails: listOrderDetails,
            ordersBloc: _ordersBloc,
            scaffoldMessengerKey: scaffoldMessengerKey,
          );
        }
        return const OrdersLoadingList();
      },
    );
  }
}

class OrdersWithResultList extends StatelessWidget {
  const OrdersWithResultList({
    required this.listOrderDetails,
    required this.ordersBloc,
    this.scaffoldMessengerKey,
    super.key,
  });

  final List<OrderDetails> listOrderDetails;
  final OrdersBlocTest ordersBloc;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:
          const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final orderDetails = listOrderDetails[index];
            Future<String> deleteOrder() =>
                ordersBloc.deleteOrder(orderDetails.id);
            return OrderCard(
              orderDetails: orderDetails,
              deleteOrder: deleteOrder,
              scaffoldMessengerKey: scaffoldMessengerKey,
            );
          },
          childCount: listOrderDetails.length,
        ),
      ),
    );
  }
}

class OrdersEmptyList extends StatelessWidget {
  const OrdersEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No orders yet.',
              style: context.headlineMedium
                  ?.copyWith(fontWeight: AppFontWeight.semiBold),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(kDefaultBorderRadius + 6),
                  ),
                ),
                backgroundColor: const WidgetStatePropertyAll(AppColors.indigo),
              ),
              onPressed: () => context.goToHome(),
              child: Text(
                'Make some.',
                style: context.bodyLarge?.apply(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersGenericError extends StatelessWidget {
  const OrdersGenericError({required this.tryAgain, super.key});

  final void Function() tryAgain;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
        ),
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
                    borderRadius:
                        BorderRadius.circular(kDefaultBorderRadius + 6),
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
      ),
    );
  }
}

class OrdersNetworkError extends StatelessWidget {
  const OrdersNetworkError({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No internet connection😕',
              style: context.headlineSmall,
            ),
            Text(
              'Check your connection status and try again',
              textAlign: TextAlign.center,
              style: context.bodyMedium?.apply(color: AppColors.grey),
            ),
            Assets.images.noInternet.image(),
          ],
        ),
      ),
    );
  }
}

class OrdersLoadingList extends StatelessWidget {
  const OrdersLoadingList({super.key});

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
