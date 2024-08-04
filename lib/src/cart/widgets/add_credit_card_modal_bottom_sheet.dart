// ignore_for_file: parameter_assignments

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/payments/payments.dart';

class AddCreditCardModalBottomSheet extends StatefulWidget {
  const AddCreditCardModalBottomSheet({super.key});

  @override
  State<AddCreditCardModalBottomSheet> createState() =>
      _AddCreditCardModalBottomSheetState();
}

class _AddCreditCardModalBottomSheetState
    extends State<AddCreditCardModalBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late CreditCard _creditCard;

  bool _isValidCreditCardNumber(String? creditCardNumber) {
    if (creditCardNumber == null || creditCardNumber.isEmpty) {
      return false;
    }

    creditCardNumber = creditCardNumber.replaceAll(' ', '');

    try {
      if (creditCardNumber.length < 13 || creditCardNumber.length > 19) {
        return false;
      }

      var sum = 0;
      var alternate = false;

      for (var i = creditCardNumber.length - 1; i >= 0; i--) {
        var n = int.tryParse(creditCardNumber[i]);

        if (n == null) {
          return false;
        }

        if (alternate) {
          n *= 2;

          if (n > 9) {
            n = (n % 10) + 1;
          }
        }

        sum += n;
        alternate = !alternate;
      }

      return (sum % 10 == 0);
    } catch (e) {
      rethrow;
    }
  }

  void onCreditCardModelChange(
    CreditCardModel? card,
  ) {
    if (card != null) {
      _creditCard = CreditCard(
        number: card.cardNumber,
        expiryDate: card.expiryDate,
        cvv: card.cvvCode,
      );
    }
  }

  void saveCreditCard() {
    if (!_formKey.currentState!.validate()) return;
    if (!_isValidCreditCardNumber(_creditCard.number)) return;

    context.read<PaymentsBloc>().add(
          PaymentsCreateCardRequested(
            card: _creditCard,
            onSuccess: (newCard) {
              context.read<SelectedCardCubit>().selectCard(newCard);
              context.read<PaymentsBloc>().add(
                    PaymentsUpdateRequested(
                      update: PaymentsDataUpdate(
                        newCreditCard: newCard,
                        type: DataUpdateType.create,
                      ),
                    ),
                  );
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = context
        .select((PaymentsBloc bloc) => bloc.state.status.isProcessingCard);

    return Builder(
      builder: (context) {
        return BlocListener<PaymentsBloc, PaymentsState>(
          listener: (_, state) {
            if (state.status.isProcessingCardSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Successfully created a credit card.'),
                ),
              );
              context.pop();
            }
            if (state.status.isProcessingCardFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Credit card already exists.'),
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: context.viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xlg,
                    vertical: AppSpacing.lg + AppSpacing.xs,
                  ),
                  child: Text(
                    'Add card',
                    style: context.headlineSmall
                        ?.copyWith(fontWeight: AppFontWeight.semiBold),
                  ),
                ),
                CreditCardForm(
                  formKey: _formKey,
                  cardNumber: '',
                  expiryDate: '',
                  cvvCode: '',
                  cardHolderName: '',
                  obscureCvv: true,
                  isHolderNameVisible: false,
                  onCreditCardModelChange: onCreditCardModelChange,
                  inputConfiguration: InputConfiguration(
                    cardNumberDecoration: InputDecoration(
                      labelText: 'Credit card number',
                      hintText: 'xxxx xxxx xxxx xxxx',
                      alignLabelWithHint: true,
                      labelStyle: context.bodyMedium,
                    ),
                    expiryDateDecoration: InputDecoration(
                      labelText: 'Expiry date',
                      hintText: 'mm / yy',
                      alignLabelWithHint: true,
                      labelStyle: context.bodyMedium,
                    ),
                    cvvCodeDecoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      alignLabelWithHint: true,
                      labelStyle: context.bodyMedium,
                    ),
                  ),
                  cardNumberValidator: (p0) {
                    if (!_isValidCreditCardNumber(p0)) {
                      return 'Invalid credit card number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: ShadButton(
                    onPressed: saveCreditCard,
                    width: double.infinity,
                    icon: !isProcessing
                        ? null
                        : const Padding(
                            padding: EdgeInsets.only(right: AppSpacing.md),
                            child: SizedBox.square(
                              dimension: AppSpacing.lg,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                    enabled: !isProcessing,
                    text: Text(isProcessing ? 'Please wait' : 'Add'),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }
}
