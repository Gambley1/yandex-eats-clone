// ignore_for_file: cascade_invocations

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/cart/bloc/payment_bloc.dart';
import 'package:papa_burger/src/cart/bloc/selected_card_notifier.dart';
import 'package:papa_burger/src/cart/widgets/add_credit_card_modal_bottom_sheet.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';

class ChoosePaymentModalBottomSheet extends StatelessWidget {
  ChoosePaymentModalBottomSheet({super.key, this.allowDelete = false});

  final bool allowDelete;

  final _paymentBloc = PaymentBloc();

  final _selectedCardNotifier = SelectedCardNotifier();

  Future<dynamic> _showAddCreditCardModalBottomSheet(BuildContext context) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
        ),
        isScrollControlled: true,
        builder: (context) {
          return const AddCreditCardModalBottomSheet();
        },
      );

  Column _buildRow(BuildContext context) {
    ListTile toAddCard() => ListTile(
          onTap: () => _showAddCreditCardModalBottomSheet(context),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          title: const Text('Link a new credit card'),
          trailing: AppIcon(
            icon: Icons.adaptive.arrow_forward_sharp,
            size: 16,
          ),
          leading: const AppIcon(
            icon: LucideIcons.creditCard,
            size: 28,
          ),
        );

    return Column(
      children: [
        toAddCard(),
        const SizedBox(
          height: 64,
        ),
      ],
    );
  }

  Widget _buildCreditCardsList(BuildContext context) {
    return StreamBuilder<List<CreditCard>>(
      stream: _paymentBloc.creditCardsStream,
      builder: (context, snapshot) {
        final creditCards = snapshot.data;
        final loading = snapshot.connectionState == ConnectionState.waiting;
        final noData =
            creditCards == null || creditCards.isEmpty || !snapshot.hasData;

        if (snapshot.hasError) {
          return _buildRow(context);
        }
        if (loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 98),
            child: AppCircularProgressIndicator(color: Colors.black),
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
                      horizontal: AppSpacing.md,
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    groupValue: selectedCard,
                    title: Text(
                      'VISA •• ${card.number.characters.getRange(15, 19)}',
                    ),
                    subtitle: allowDelete
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _paymentBloc.deleteCard(context, card),
                                child: Row(
                                  children: [
                                    const AppIcon(
                                      icon: LucideIcons.trash,
                                      size: 14,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      'Delete',
                                      style: context.bodyMedium
                                          ?.apply(color: AppColors.red),
                                    ),
                                  ],
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
    logI('Build');
    return AppBottomSheet(
      title: 'Payment methods',
      content: _buildCreditCardsList(context),
    );
  }
}
