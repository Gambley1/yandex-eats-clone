import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:yandex_food_api/client.dart';

class OrderMenuItemTile extends StatelessWidget {
  const OrderMenuItemTile({
    required this.orderMenuItem,
    super.key,
  });

  final OrderMenuItem orderMenuItem;

  @override
  Widget build(BuildContext context) {
    final imageUrl = orderMenuItem.imageUrl;
    final name = orderMenuItem.name;
    final quantity = orderMenuItem.quantity;
    final price = orderMenuItem.price.currencyFormat();

    return ListTile(
      horizontalTitleGap: AppSpacing.md,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md - AppSpacing.xs),
      leading: ImageAttachmentThumbnail.network(
        height: 50,
        width: 50,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        imageUrl: imageUrl,
      ),
      title: Text(name),
      subtitle: Text('$quantity pcs'),
      subtitleTextStyle: context.bodyMedium?.apply(color: AppColors.grey),
      trailing: Text(price),
      leadingAndTrailingTextStyle: context.bodyLarge,
    );
  }
}
