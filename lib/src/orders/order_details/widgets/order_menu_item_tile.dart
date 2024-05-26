import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

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
      horizontalTitleGap: 12,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md - AppSpacing.xs),
      leading: AppCachedImage(
        height: 50,
        width: 50,
        imageUrl: imageUrl,
        imageType: CacheImageType.sm,
      ),
      title: Text(name),
      subtitle: Text('$quantity pcs'),
      trailing: Text(price),
    );
  }
}
