import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/utils/app_constants.dart';
import 'package:papa_burger/src/models/order/order_menu_item.dart';
import 'package:papa_burger/src/restaurant.dart'
    show CacheImageType, CachedImage, KText, currency;

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
    final price = '${orderMenuItem.price}$currency';
    return ListTile(
      horizontalTitleGap: 12,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding - 4),
      leading: CachedImage(
        height: 50,
        width: 50,
        imageUrl: imageUrl,
        imageType: CacheImageType.smallImage,
      ),
      title: KText(text: name),
      subtitle: KText(text: '$quantity pcs'),
      trailing: KText(text: price),
    );
  }
}
