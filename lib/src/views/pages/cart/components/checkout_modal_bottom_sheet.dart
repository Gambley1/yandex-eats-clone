// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/models/payment/credit_card.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomIcon,
        CustomScaffold,
        IconType,
        KText,
        LocationNotifier,
        LocationService,
        NavigatorExtension;
import 'package:papa_burger/src/views/pages/cart/components/cart_bottom_app_bar.dart';
import 'package:papa_burger/src/views/pages/cart/components/choose_payment_modal_bottom_sheet.dart';
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';

class CheckoutModalBottomSheet extends StatelessWidget {
  CheckoutModalBottomSheet({super.key});

  final LocationService _locationService = LocationService();
  final SelectedCardNotifier _cardNotifier = SelectedCardNotifier();

  late final LocationNotifier _locationNotifier =
      _locationService.locationNotifier;

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
            : CustomIcon(
                icon: icon,
                size: 20,
                type: IconType.simpleIcon,
              ),
        title: LimitedBox(
          maxWidth: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KText(maxLines: 1, text: title),
              KText(
                maxLines: 1,
                text: subtitle,
                size: 14,
                color: Colors.grey.shade500,
              ),
              const SizedBox(height: 12),
              const Divider(
                height: 2,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        trailing: const CustomIcon(
          icon: Icons.arrow_forward_ios_outlined,
          type: IconType.simpleIcon,
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
            'street ${_locationNotifier.value}',
            'Leave an order comment please',
            FontAwesomeIcons.house,
            () => context.navigateToGoolgeMapView(),
          );

      ListTile deliveryTimeInfo() => buildRow(
            context,
            'Delivery 30-40 minutes',
            'But it might even be faster',
            FontAwesomeIcons.clock,
            () => context.navigateToMainPage(),
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

    return CustomScaffold(
      bottomNavigationBar: CartBottomAppBar(
        info: 'Total',
        title: 'Pay',
        onTap: () => _cardNotifier.value == const CreditCard.empty()
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
            valueListenable: _cardNotifier,
            builder: (context, selectedCard, _) {
              final noSeletction = selectedCard == const CreditCard.empty();
              return ListTile(
                onTap: () => showChoosePaymentModalBottomSheet(context),
                title: KText(
                  text: noSeletction
                      ? 'Choose payment method'
                      : 'VISA •• ${selectedCard.number.characters.getRange(15, 19)}',
                  color: noSeletction ? Colors.red : Colors.black,
                ),
                trailing: const CustomIcon(
                  icon: Icons.arrow_forward_ios_sharp,
                  type: IconType.simpleIcon,
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
