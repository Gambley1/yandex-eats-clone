import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.orderDetails,
    required this.deleteOrder,
    super.key,
  });

  final OrderDetails orderDetails;
  final VoidCallback deleteOrder;

  Color _statusColor(OrderStatus status) => switch (status) {
        OrderStatus.pedning => Colors.yellow.shade800,
        OrderStatus.canceled => Colors.red,
        OrderStatus.completed => Colors.green,
      };

  @override
  Widget build(BuildContext context) {
    final restaurantName = orderDetails.restaurantName;
    final orderTotal = orderDetails.totalOrderSum;
    final date = orderDetails.date;
    final status = orderDetails.status;
    final menuItems = orderDetails.orderMenuItems;
    final orderId = orderDetails.id;

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoutes.orderDetails.name,
        pathParameters: {'order_id': orderId},
      ),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
        ),
        shadowColor: Colors.grey.withOpacity(.5),
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
                      AppIcon(
                        icon: LucideIcons.trash,
                        type: IconType.button,
                        size: 18,
                        color: Colors.red,
                        onPressed: deleteOrder,
                      ),
                    ],
                  ),
                  Text(
                    orderTotal.round().currencyFormat(),
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
                    style: context.bodyMedium
                        ?.apply(color: AppColors.grey.withOpacity(.6)),
                  ),
                  Text(
                    status.name,
                    style:
                        context.bodyMedium?.apply(color: _statusColor(status)),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: menuItems.map((e) {
                  return AppCachedImage(
                    height: 40,
                    width: 40,
                    imageUrl: e.imageUrl,
                    imageType: CacheImageType.sm,
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
