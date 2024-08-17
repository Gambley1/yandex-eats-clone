import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/error/error.dart';
import 'package:yandex_food_delivery_clone/src/orders/orders.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state.status.isLoading) {
          context.read<OrdersBloc>().add(const OrdersFetchRequested());
        }
      },
      listenWhen: (previous, current) {
        return previous.status != current.status ||
            !const ListEquality<Order>()
                .equals(previous.orders, current.orders);
      },
      buildWhen: (previous, current) {
        return previous.status != current.status ||
            !const ListEquality<Order>()
                .equals(previous.orders, current.orders);
      },
      builder: (context, state) {
        final status = state.status;
        final orders = state.orders;
        return switch ((status, orders.isEmpty)) {
          (OrdersStatus.loading, _) => const OrdersLoading(),
          (OrdersStatus.failure, _) => const OrdersFailure(),
          (_, true) => const OrdersEmptyList(),
          (_, _) => const OrdersList(),
        };
      },
    );
  }
}

class OrdersList extends StatelessWidget {
  const OrdersList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final orders = context.select((OrdersBloc bloc) => bloc.state.orders);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      sliver: SliverList.builder(
        itemBuilder: (context, index) {
          final order = orders[index];

          return OrderCard(order: order);
        },
        itemCount: orders.length,
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
          onPressed: () => context.goNamed(AppRoutes.restaurants.name),
          buttonLabel: 'Explore',
          icon: LucideIcons.search,
        ),
      ),
    );
  }
}

class OrdersFailure extends StatelessWidget {
  const OrdersFailure({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: ErrorView(
        onTryAgain: () =>
            context.read<OrdersBloc>().add(const OrdersRefreshRequested()),
      ),
    );
  }
}

class OrdersLoading extends StatelessWidget {
  const OrdersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: AppCircularProgressIndicator(),
    );
  }
}
