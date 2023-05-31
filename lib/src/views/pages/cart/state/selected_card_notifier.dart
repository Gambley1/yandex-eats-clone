import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:papa_burger/src/models/payment/credit_card.dart';
import 'package:papa_burger/src/restaurant.dart' show LocalStorage, logger;

class SelectedCardNotifier extends ValueNotifier<CreditCard> {
  factory SelectedCardNotifier() => _instance;

  SelectedCardNotifier._privateConstructor(super.value) {
    _getSelectedCardFromCookie();
  }
  static final SelectedCardNotifier _instance =
      SelectedCardNotifier._privateConstructor(
    const CreditCard.empty(),
  );

  final LocalStorage _localStorage = LocalStorage.instance;

  void chooseCreditCard(CreditCard? card) {
    logger.w('Chose card ${card?.toMap()}');
    if (card != null) {
      value = card;
      _localStorage.saveCreditCardSelection(value);
    }
  }

  void deleteCardSelection() {
    value = const CreditCard.empty();
    _localStorage.deleteCreditCardSelection();
    logger.w(
      'Deleted card selection. Current card $value, and from Local Storage '
      '${_localStorage.getSelectedCreditCard}',
    );
  }

  void _getSelectedCardFromCookie() {
    value = _localStorage.getSelectedCreditCard;
  }
}
