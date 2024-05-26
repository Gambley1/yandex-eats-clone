import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/error/error.dart';
import 'package:papa_burger/src/home/home.dart';
import 'package:papa_burger/src/home/widgets/widgets.dart';
import 'package:papa_burger/src/orders/bloc/orders_bloc_test.dart';
import 'package:papa_burger/src/orders/bloc/orders_result.dart';
import 'package:papa_burger/src/orders/widgets/order_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({
    required this.ordersBloc,
    super.key,
  });

  final OrdersBlocTest ordersBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrdersResult>(
      stream: ordersBloc.orders,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state is OrdersError) {
          final error = state.error;
          if (error is NetworkException) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.showSnackBar(
                error.message,
                dismissible: false,
                duration: const Duration(days: 1),
                behavior: SnackBarBehavior.floating,
                snackBarAction: SnackBarAction(
                  label: 'Try again',
                  textColor: Colors.indigo.shade400,
                  onPressed: ordersBloc.tryGetOrdersAgain,
                ),
              );
            });
            return const OrdersNetworkError();
          }
          return OrdersGenericError(tryAgain: ordersBloc.tryGetOrdersAgain);
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
            ordersBloc: ordersBloc,
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
    super.key,
  });

  final List<OrderDetails> listOrderDetails;
  final OrdersBlocTest ordersBloc;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final orderDetails = listOrderDetails[index];
            Future<String> deleteOrder() =>
                ordersBloc.deleteOrder(orderDetails.id);
            return OrderCard(
              orderDetails: orderDetails,
              deleteOrder: deleteOrder,
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
          horizontal: AppSpacing.md,
        ),
        child: AppInfoSection(
          info: 'No orders yet.',
          onPressed: () => HomeConfig().goBranch(0),
          buttonLabel: 'Explore',
          icon: LucideIcons.search,
        ),
      ),
    );
  }
}

class OrdersGenericError extends StatelessWidget {
  const OrdersGenericError({required this.tryAgain, super.key});

  final VoidCallback tryAgain;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: ErrorView(onTryAgain: tryAgain),
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
          horizontal: AppSpacing.md,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No internet connection 😕',
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
      child: AppCircularProgressIndicator(
        color: Colors.black,
      ),
    );
  }
}
