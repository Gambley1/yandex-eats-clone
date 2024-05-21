// ignore_for_file: parameter_assignments

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/credit_card.dart';
import 'package:papa_burger/src/views/pages/cart/state/payment_bloc.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class AddCreditCardModalBottomSheet extends StatefulWidget {
  const AddCreditCardModalBottomSheet({super.key});

  @override
  State<AddCreditCardModalBottomSheet> createState() =>
      _AddCreditCardModalBottomSheetState();
}

class _AddCreditCardModalBottomSheetState
    extends State<AddCreditCardModalBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  CreditCard? _creditCard;

  bool _isValidCreditCardNumber(String? creditCardNumber) {
    if (creditCardNumber == null || creditCardNumber.isEmpty) {
      return false;
    }

    creditCardNumber = creditCardNumber.replaceAll(' ', '');
    // logI('Credit Card number $creditCardNumber');

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
      logI(e.toString());
      rethrow;
    }
  }

  void onCreditCardModelChange(
    CreditCardModel? card,
  ) {
    if (_formKey.currentState!.validate()) {
      if (card != null) {
        _creditCard = CreditCard(
          number: card.cardNumber,
          expiry: card.expiryDate,
          cvv: card.cvvCode,
        );
        logI('Credit Card ${_creditCard?.toMap()}');
      }
    }
  }

  void saveCreditCard() {
    if (_formKey.currentState!.validate()) {
      try {
        if (_isValidCreditCardNumber(_creditCard?.number) &&
            _creditCard != null) {
          PaymentBloc().addCard(context, _creditCard!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully saved Credit card!'),
            ),
          );
          logI('Credit card saved');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid credit card number'),
            ),
          );
          logW('Failed to save Credit card');
        }
      } catch (e) {
        logE(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add credit card.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalBottomSheet(
      withAdditionalPadding: false,
      title: 'Adding a credit card',
      content: Column(
        children: [
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cardNumberValidator: (p0) {
              if (!_isValidCreditCardNumber(p0)) {
                return 'Invalid credit card number.';
              }
              return null;
            },
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
              child: const KText(text: 'Add', size: 19),
            ),
          ),
        ],
      ),
    );
  }
}
