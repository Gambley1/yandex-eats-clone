// ignore_for_file: cascade_invocations

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/cart/widgets/add_credit_card_modal_bottom_sheet.dart';
import 'package:yandex_food_delivery_clone/src/payments/payments.dart';

class ChoosePaymentBottomView extends StatefulWidget {
  const ChoosePaymentBottomView({super.key, this.allowDelete = false});

  final bool allowDelete;

  @override
  State<ChoosePaymentBottomView> createState() =>
      _ChoosePaymentBottomViewState();
}

class _ChoosePaymentBottomViewState extends State<ChoosePaymentBottomView> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentsBloc>().add(const PaymentsFetchCardsRequested());
  }

  Future<dynamic> _showAddCreditCardModalBottomSheet(BuildContext context) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.white,
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
            iconSize: 16,
          ),
          leading: const AppIcon(
            icon: LucideIcons.creditCard,
            iconSize: 28,
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
    final creditCards =
        context.select((PaymentsBloc bloc) => bloc.state.creditCards);
    final isLoading =
        context.select((PaymentsBloc bloc) => bloc.state.status.isLoading);
    final isFailure =
        context.select((PaymentsBloc bloc) => bloc.state.status.isFailure);
    final selectedCard =
        context.select((SelectedCardCubit cubit) => cubit.state.selectedCard);

    if (isFailure) {
      return _buildRow(context);
    }
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 98),
        child: AppCircularProgressIndicator(color: AppColors.black),
      );
    }
    if (creditCards.isEmpty) {
      return _buildRow(context);
    }

    return Column(
      children: [
        ...creditCards.map(
          (card) => RadioListTile(
            value: card,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            controlAffinity: ListTileControlAffinity.trailing,
            groupValue: selectedCard,
            title: Text(
              'VISA •• ${card.number.characters.getRange(15, 19)}',
            ),
            subtitle: widget.allowDelete
                ? Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<PaymentsBloc>()
                            ..add(
                              PaymentsDeleteCardRequested(
                                number: card.number,
                                onComplete: () {
                                  if (selectedCard != card) return;
                                  context
                                      .read<SelectedCardCubit>()
                                      .getSelectedCard();
                                },
                              ),
                            )
                            ..add(
                              PaymentsUpdateRequested(
                                update: PaymentsDataUpdate(
                                  newCreditCard: card,
                                  type: DataUpdateType.delete,
                                ),
                              ),
                            );
                        },
                        child: Row(
                          children: [
                            const AppIcon(
                              icon: LucideIcons.trash,
                              iconSize: 14,
                              color: AppColors.red,
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
            activeColor: AppColors.green,
            onChanged: (card) =>
                context.read<SelectedCardCubit>().selectCard(card!),
          ),
        ),
        _buildRow(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'Payment methods',
      content: _buildCreditCardsList(context),
    );
  }
}
