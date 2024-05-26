import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/cart/bloc/selected_card_notifier.dart';
import 'package:papa_burger/src/cart/widgets/cart_bottom_app_bar.dart';
import 'package:papa_burger/src/cart/widgets/choose_payment_modal_bottom_sheet.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/bloc/location_bloc.dart';
import 'package:papa_burger/src/home/home.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';

class CheckoutModalBottomSheet extends StatelessWidget {
  const CheckoutModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    ListTile buildRow(
      BuildContext context,
      String title,
      String subtitle,
      IconData? icon,
      void Function()? onTap,
    ) {
      return ListTile(
        onTap: onTap,
        horizontalTitleGap: 0,
        leading: icon == null
            ? null
            : AppIcon(
                icon: icon,
                size: 20,
              ),
        title: LimitedBox(
          maxWidth: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(maxLines: 1, title),
              Text(
                subtitle,
                maxLines: 1,
                style: context.bodyMedium
                    ?.apply(color: AppColors.grey.withOpacity(.5)),
              ),
              const SizedBox(height: 12),
              const Divider(
                height: 2,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        trailing: AppIcon(
          icon: Icons.adaptive.arrow_forward_sharp,
          size: 14,
        ),
      );
    }

    ListTile buildRowWithInfo(
      BuildContext context, {
      bool forAddressInfo = true,
    }) {
      ListTile addressInfo() => buildRow(
            context,
            'street ${LocationNotifier().value}',
            'Leave an order comment please 🙏',
            LucideIcons.home,
            () => context.pushNamed(AppRoutes.googleMap.name),
          );

      ListTile deliveryTimeInfo() => buildRow(
            context,
            'Delivery 30-40 minutes',
            'But it might even be faster',
            LucideIcons.clock,
            () => HomeConfig().goBranch(0),
          );

      if (forAddressInfo) return addressInfo();
      return deliveryTimeInfo();
    }

    Future<void> showChoosePaymentModalBottomSheet(BuildContext context) =>
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return ChoosePaymentModalBottomSheet();
          },
        );

    return AppScaffold(
      bottomNavigationBar: CartBottomAppBar(
        info: 'Total',
        title: 'Pay',
        onTap: () => SelectedCardNotifier().value == const CreditCard.empty()
            ? showChoosePaymentModalBottomSheet(context)
            : () {},
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRowWithInfo(context),
          const SizedBox(
            height: 12,
          ),
          buildRowWithInfo(context, forAddressInfo: false),
          const SizedBox(
            height: 6,
          ),
          ValueListenableBuilder<CreditCard>(
            valueListenable: SelectedCardNotifier(),
            builder: (context, selectedCard, _) {
              final noSelection = selectedCard == const CreditCard.empty();
              return ListTile(
                onTap: () => showChoosePaymentModalBottomSheet(context),
                title: Text(
                  noSelection
                      ? 'Choose payment method'
                      : 'VISA •• '
                          '${selectedCard.number.characters.getRange(15, 19)}',
                  style: context.bodyMedium
                      ?.apply(color: noSelection ? Colors.red : Colors.black),
                ),
                trailing: AppIcon(
                  icon: Icons.adaptive.arrow_forward_sharp,
                  size: 14,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
