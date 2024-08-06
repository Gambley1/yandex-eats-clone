import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_delivery_clone/src/payments/payments.dart';

class PaymentsModalView extends StatefulWidget {
  const PaymentsModalView({
    required this.scrollController,
    super.key,
    this.canDeleteCards = false,
  });

  final bool canDeleteCards;
  final ScrollController scrollController;

  @override
  State<PaymentsModalView> createState() => _PaymentsModalViewState();
}

class _PaymentsModalViewState extends State<PaymentsModalView> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentsBloc>().add(const PaymentsFetchCardsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final creditCards =
        context.select((PaymentsBloc bloc) => bloc.state.creditCards);
    final isLoading =
        context.select((PaymentsBloc bloc) => bloc.state.status.isLoading);
    final isFailure =
        context.select((PaymentsBloc bloc) => bloc.state.status.isFailure);
    final selectedCard =
        context.select((SelectedCardCubit cubit) => cubit.state.selectedCard);

    if (isFailure) return const LinkCreditCardListTile();
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 98),
        child: AppCircularProgressIndicator(),
      );
    }
    if (creditCards.isEmpty) return const LinkCreditCardListTile();

    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xlg,
              vertical: AppSpacing.lg + AppSpacing.xs,
            ),
            child: Text(
              'Payment methods',
              style: context.headlineSmall,
            ),
          ),
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
              subtitle: widget.canDeleteCards
                  ? DeleteCardButton(card: card, selectedCard: selectedCard)
                  : null,
              activeColor: AppColors.green,
              onChanged: (card) =>
                  context.read<SelectedCardCubit>().selectCard(card!),
            ),
          ),
          const LinkCreditCardListTile(),
        ],
      ),
    );
  }
}
