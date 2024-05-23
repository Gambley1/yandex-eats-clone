import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';
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
          const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding - 4),
      leading: CachedImage(
        height: 50,
        width: 50,
        imageUrl: imageUrl,
        imageType: CacheImageType.smallImage,
      ),
      title: Text(name),
      subtitle: Text('$quantity pcs'),
      trailing: Text(price),
    );
  }
}
