import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:papa_burger/src/models/credit_card.dart';
import 'package:papa_burger/src/services/storage/storage.dart';

class SelectedCardNotifier extends ValueNotifier<CreditCard> {
  factory SelectedCardNotifier() => _instance;

  SelectedCardNotifier._privateConstructor(super.value) {
    _getSelectedCardFromCookie();
  }
  static final SelectedCardNotifier _instance =
      SelectedCardNotifier._privateConstructor(
    const CreditCard.empty(),
  );

  void chooseCreditCard(CreditCard? card) {
    if (card != null) {
      value = card;
      LocalStorage().saveCreditCardSelection(value);
    }
  }

  void deleteCardSelection() {
    value = const CreditCard.empty();
    LocalStorage().deleteCreditCardSelection();
  }

  void _getSelectedCardFromCookie() {
    value = LocalStorage().getSelectedCreditCard;
  }
}
