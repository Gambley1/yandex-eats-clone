import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/orders/orders.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.order,
    super.key,
  });

  final Order order;

  Color _statusColor(OrderStatus status) => switch (status) {
        OrderStatus.pending => AppColors.orangeAccent,
        OrderStatus.canceled => AppColors.red,
        OrderStatus.completed => AppColors.green,
      };

  @override
  Widget build(BuildContext context) {
    final restaurantName = order.restaurantName;
    final orderTotal = order.totalOrderSum;
    final date = order.date;
    final status = order.status;
    final menuItems = order.items;
    final orderId = order.id;

    return Tappable(
      onTap: () => context.pushNamed(
        AppRoutes.order.name,
        pathParameters: {'order_id': orderId},
      ),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
        ),
        shadowColor: AppColors.grey.withOpacity(.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        restaurantName,
                        style: context.titleLarge
                            ?.copyWith(fontWeight: AppFontWeight.semiBold),
                      ),
                      AppIcon.button(
                        icon: LucideIcons.trash,
                        color: AppColors.red,
                        onTap: () => context
                            .read<OrdersBloc>()
                            .add(OrdersDeleteOrderRequested(orderId: orderId)),
                      ),
                    ],
                  ),
                  Text(
                    orderTotal.currencyFormat(),
                    style: context.titleLarge
                        ?.copyWith(fontWeight: AppFontWeight.semiBold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: context.bodyMedium?.apply(color: AppColors.grey),
                  ),
                  Text(
                    status.toJson(),
                    style:
                        context.bodyMedium?.apply(color: _statusColor(status)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: menuItems.map((e) {
                  return ImageAttachmentThumbnail.network(
                    height: 40,
                    width: 40,
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                    imageUrl: e.imageUrl,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
