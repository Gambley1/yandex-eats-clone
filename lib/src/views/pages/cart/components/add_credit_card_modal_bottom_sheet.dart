import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/views/pages/cart/state/payment_bloc.dart';

import '../../../../models/payment/credit_card.dart';
import '../../../widgets/custom_modal_bottom_sheet.dart';

class AddCreditCardModalBottomSheet extends StatelessWidget {
  const AddCreditCardModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentBloc paymentBloc = PaymentBloc();

    final formKey = GlobalKey<FormState>();

    const String cardNumber = '';

    const String expiryDate = '';

    const String cvvCode = '';

    CreditCard? creditCard;

    bool isValidCreditCardNumber(String? creditCardNumber) {
      if (creditCardNumber == null || creditCardNumber.isEmpty) {
        return false;
      }

      creditCardNumber = creditCardNumber.replaceAll(' ', '');
      logger.w('creditCardNumber $creditCardNumber');

      if (creditCardNumber.length < 13 || creditCardNumber.length > 19) {
        return false;
      }

      int sum = 0;
      bool alternate = false;

      for (int i = creditCardNumber.length - 1; i >= 0; i--) {
        int n = int.parse(creditCardNumber[i]);

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
    }

    void onCreditCardModelChange(CreditCardModel? card) {
      if (formKey.currentState!.validate()) {
        if (card != null) {
          creditCard = CreditCard(
            number: card.cardNumber,
            expiry: card.expiryDate,
            cvv: card.cvvCode,
          );
          logger.w('Credit Card ${creditCard?.toMap()}');
        }
      }
    }

    void saveCreditCard() {
      if (formKey.currentState!.validate()) {
        if (isValidCreditCardNumber(creditCard?.number) && creditCard != null) {
          paymentBloc.addCard(context, creditCard!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Succesfully saved Credit card!'),
            ),
          );
          logger.w('Credit card saved');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid credit card number'),
            ),
          );
          logger.w('Failed to save Credit card');
        }
      }
    }

    return CustomModalBottomSheet(
      withAdditionalPadding: false,
      title: 'Adding a credit card',
      content: Column(
        children: [
          CreditCardForm(
            formKey: formKey,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cvvCode: cvvCode,
            cardHolderName: '',
            obscureCvv: true,
            isHolderNameVisible: false,
            onCreditCardModelChange: onCreditCardModelChange,
            themeColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: Colors.blue,
            cardNumberValidator: (p0) {
              if (!isValidCreditCardNumber(p0)) {
                return 'Invalid credit card number.';
              }
              return null;
            },
            cardNumberDecoration: InputDecoration(
              labelText: 'Credit card number',
              alignLabelWithHint: true,
              labelStyle: GoogleFonts.getFont(
                'Quicksand',
                textStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),
            expiryDateDecoration: InputDecoration(
              labelText: 'mm / yy',
              alignLabelWithHint: true,
              labelStyle: GoogleFonts.getFont(
                'Quicksand',
                textStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),
            cvvCodeDecoration: InputDecoration(
              labelText: 'CVV',
              alignLabelWithHint: true,
              labelStyle: GoogleFonts.getFont(
                'Quicksand',
                textStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: saveCreditCard,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                vertical: kDefaultHorizontalPadding + 16,
                horizontal: kDefaultHorizontalPadding,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: kDefaultHorizontalPadding,
              ),
              decoration: BoxDecoration(
                color: kPrimaryBackgroundColor,
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              ),
              child: const KText(
                text: 'Add',
                size: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
