import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/payments/payments.dart';

class DeleteCardButton extends StatelessWidget {
  const DeleteCardButton({
    required this.card,
    required this.selectedCard,
    super.key,
  });

  final CreditCard card;
  final CreditCard selectedCard;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tappable.faded(
          onTap: () {
            context.read<PaymentsBloc>()
              ..add(
                PaymentsDeleteCardRequested(
                  number: card.number,
                  onComplete: () {
                    if (selectedCard != card) return;
                    context.read<SelectedCardCubit>().getSelectedCard();
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
                iconSize: AppSize.xs,
                color: AppColors.red,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Delete',
                style: context.bodyMedium?.apply(color: AppColors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
