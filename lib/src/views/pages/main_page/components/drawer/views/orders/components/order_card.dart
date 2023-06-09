import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:papa_burger/src/models/order/order_details.dart';
import 'package:papa_burger/src/restaurant.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.orderDetails,
    required this.deleteOrder,
    this.scaffoldMessengerKey,
    super.key,
  });

  final OrderDetails orderDetails;
  final void Function() deleteOrder;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  @override
  Widget build(BuildContext context) {
    final restaurantName = orderDetails.restaurantName;
    final orderTotal = orderDetails.totalOrderSumm;
    final date = orderDetails.date;
    final status = orderDetails.status;
    final menuItems = orderDetails.orderMenuItems;
    final orderId = orderDetails.id;
    return GestureDetector(
      onTap: () =>
          context.navigateToOrderDetailsView(orderId, scaffoldMessangerKey: scaffoldMessengerKey),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
        shadowColor: Colors.grey.withOpacity(.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: kDefaultVerticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      KText(
                        text: restaurantName,
                        size: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomIcon(
                        icon: FontAwesomeIcons.trash,
                        type: IconType.iconButton,
                        size: 18,
                        color: Colors.red,
                        onPressed: deleteOrder,
                      ),
                    ],
                  ),
                  KText(
                    text: '${orderTotal.round()}$currency',
                    size: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: date,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  KText(
                    text: status,
                    color: statusColor(status),
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
                  return CachedImage(
                    height: 40,
                    width: 40,
                    imageUrl: e.imageUrl,
                    imageType: CacheImageType.smallImage,
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
