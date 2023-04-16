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
        NavigatorExtension,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding;
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';

import 'cart_bottom_app_bar.dart';
import 'choose_payment_modal_bottom_sheet.dart';

class CheckoutModalBottomSheet extends StatelessWidget {
  CheckoutModalBottomSheet({super.key});

  final LocationService _locationService = LocationService();
  final SelectedCardNotifier _cardNotifier = SelectedCardNotifier();

  late final LocationNotifier _locationNotifier =
      _locationService.locationNotifier;

  @override
  Widget build(BuildContext context) {
    buildRow(
      BuildContext context,
      String title,
      String subtitle,
      IconData? icon,
      Function() onTap,
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
            mainAxisAlignment: MainAxisAlignment.start,
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

    buildRowWithInfo(
      BuildContext context, {
      bool forAddressInfo = true,
    }) {
      addressInfo() => buildRow(
            context,
            'street ${_locationNotifier.value}',
            'Leave an Order comment please ∧',
            FontAwesomeIcons.house,
            () => context.navigateToGoolgeMapView(),
          );

      deliveryTimeInfo() => buildRow(
            context,
            'Delivery 30-40 minutes',
            'But it might even be faster',
            FontAwesomeIcons.clock,
            () => context.navigateToMainPage(),
          );

      if (forAddressInfo) return addressInfo();
      return deliveryTimeInfo();
    }

    showChoosePaymentModalBottomSheet(BuildContext context) =>
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return ChoosePaymentModalBottomSheet();
          },
        );

    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kDefaultBorderRadius),
          topRight: Radius.circular(kDefaultBorderRadius),
        ),
      ),
      child: CustomScaffold(
        bottomNavigationBar: CartBottomAppBar(
          info: 'Total',
          title: 'Pay',
          onTap: () => _cardNotifier.value == const CreditCard.empty()
              ? showChoosePaymentModalBottomSheet(context)
              : () {},
        ),
        backroundColor: Colors.transparent,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: kDefaultHorizontalPadding + 8,
                bottom: kDefaultHorizontalPadding + 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              ),
              child: Column(
                children: [
                  buildRowWithInfo(context),
                  const SizedBox(
                    height: 12,
                  ),
                  buildRowWithInfo(context, forAddressInfo: false),
                ],
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kDefaultBorderRadius),
                  topRight: Radius.circular(kDefaultBorderRadius),
                ),
              ),
              child: ValueListenableBuilder<CreditCard>(
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
            ),
          ],
        ),
      ),
    );
  }
}
