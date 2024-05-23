import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';
import 'package:shared/shared.dart';

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
    final orderTotal = orderDetails.totalOrderSum;
    final date = orderDetails.date;
    final status = orderDetails.status;
    final menuItems = orderDetails.orderMenuItems;
    final orderId = orderDetails.id;

    return GestureDetector(
      onTap: () => context.goToOrderDetails(
        orderId,
        scaffoldMessengerKey: scaffoldMessengerKey,
      ),
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
                      Text(
                        restaurantName,
                        style: context.titleLarge
                            ?.copyWith(fontWeight: AppFontWeight.semiBold),
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
                    status,
                    style:
                        context.bodyMedium?.apply(color: statusColor(status)),
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
