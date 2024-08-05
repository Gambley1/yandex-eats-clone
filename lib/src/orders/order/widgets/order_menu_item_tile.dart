import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:yandex_food_api/client.dart';

class OrderMenuItemTile extends StatelessWidget {
  const OrderMenuItemTile({
    required this.item,
    super.key,
  });

  final OrderMenuItem item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.imageUrl;
    final name = item.name;
    final quantity = item.quantity;
    final price = item.price.currencyFormat();

    return ListTile(
      horizontalTitleGap: AppSpacing.md,
      contentPadding: EdgeInsets.zero,
      leading: AspectRatio(
        aspectRatio: 1,
        child: ImageAttachmentThumbnail.network(
          borderRadius: BorderRadius.circular(AppSpacing.xlg),
          imageUrl: imageUrl,
        ),
      ),
      title: Text(name),
      subtitle: Text('$quantity pcs'),
      subtitleTextStyle: context.bodyMedium?.apply(color: AppColors.grey),
      trailing: Text(price),
      leadingAndTrailingTextStyle: context.bodyLarge,
    );
  }
}
