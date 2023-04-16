import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:papa_burger/src/models/payment/credit_card.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/views/pages/cart/components/add_credit_card_modal_bottom_sheet.dart';
import 'package:papa_burger/src/views/pages/cart/state/payment_bloc.dart';
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';

import '../../../widgets/custom_modal_bottom_sheet.dart';

class ChoosePaymentModalBottomSheet extends StatelessWidget {
  ChoosePaymentModalBottomSheet({
    super.key,
    this.allowDelete = false,
  });

  final bool allowDelete;

  final PaymentBloc _paymentBloc = PaymentBloc();

  final SelectedCardNotifier _selectedCardNotifier = SelectedCardNotifier();

  _showAddCreditCardModalBottomSheet(BuildContext context) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return const AddCreditCardModalBottomSheet();
        },
      );

  _buildRow(BuildContext context) {
    toAddCard() => ListTile(
          onTap: () => _showAddCreditCardModalBottomSheet(context),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
          ),
          horizontalTitleGap: 0,
          title: const KText(
            text: 'Link a new credit card',
            size: 18,
          ),
          trailing: const CustomIcon(
            icon: Icons.arrow_forward_ios_outlined,
            type: IconType.simpleIcon,
            size: 16,
          ),
          leading: const CustomIcon(
            icon: FontAwesomeIcons.creditCard,
            type: IconType.simpleIcon,
            size: 28,
          ),
        );

    return Column(
      children: [
        toAddCard(),
        const SizedBox(
          height: 64,
        )
      ],
    );
  }

  _buildCreditCardsList(BuildContext context) {
    return StreamBuilder<List<CreditCard>>(
      stream: _paymentBloc.creditCardsStream,
      builder: (context, snapshot) {
        final creditCards = snapshot.data;
        final loading = snapshot.connectionState == ConnectionState.waiting;
        final noData =
            creditCards == null || creditCards.isEmpty || !snapshot.hasData;
        logger.w("No Data? $noData");
        logger.w('Credit Cards $creditCards');
        logger.w('Loading? $loading');

        if (snapshot.hasError) {
          return _buildRow(context);
        }
        if (loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 98),
            child: CustomCircularIndicator(color: Colors.black),
          );
        }
        if (noData) {
          return _buildRow(context);
        }

        return Column(
          children: [
            ...creditCards.map(
              (card) => ValueListenableBuilder<CreditCard>(
                valueListenable: _selectedCardNotifier,
                builder: (context, selectedCard, _) {
                  return RadioListTile(
                    value: card,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: kDefaultHorizontalPadding,
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    groupValue: selectedCard,
                    title: KText(
                      text:
                          'VISA •• ${card.number.characters.getRange(15, 19)}',
                    ),
                    subtitle: allowDelete
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _paymentBloc.deleteCard(context, card),
                                child: Row(
                                  children: const [
                                    CustomIcon(
                                      icon: FontAwesomeIcons.trash,
                                      type: IconType.simpleIcon,
                                      size: 14,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    KText(
                                      text: 'Delete',
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _paymentBloc.removeAllCreditCards();
                                },
                                child: const KText(
                                  text: 'Delete all Credit cards',
                                  size: 16,
                                ),
                              ),
                            ],
                          )
                        : null,
                    activeColor: Colors.green,
                    onChanged: _selectedCardNotifier.chooseCreditCard,
                  );
                },
              ),
            ),
            _buildRow(context),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.w('Build Choose Payment Modal Bottom Sheet');
    return CustomModalBottomSheet(
      title: 'Payment methods',
      content: _buildCreditCardsList(context),
    );
  }
}
