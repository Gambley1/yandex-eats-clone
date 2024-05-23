import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show BuildContext;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/services/network/api/payment_controller.dart';
import 'package:papa_burger/src/services/repositories/payments/payments_repository.dart';
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;
import 'package:shared/shared.dart';

@immutable
class PaymentBloc {
  factory PaymentBloc() => _instance;

  PaymentBloc._() {
    // _addCreditCardsFromFirebase;
    _addCreditCardsFromDB;
  }
  static final _instance = PaymentBloc._();

  final PaymentsRepository _paymentRepository = PaymentsRepository(
    paymentController: PaymentController(),
  );

  final SelectedCardNotifier _cardNotifier = SelectedCardNotifier();

  final _paymentSubject = BehaviorSubject<List<CreditCard>>.seeded([]);

  Stream<List<CreditCard>> get creditCardsStream =>
      _paymentSubject.distinct().asyncMap(
        (cards) async {
          final newCards = await _getCreditCards;
          cards = newCards;
          return newCards;
        },
      );

  List<CreditCard> get creditCards => _paymentSubject.value;

  void addCard(BuildContext context, CreditCard card) {
    try {
      _addCard(card);
      context.pop();
    } catch (e) {
      throw Exception(e);
    }
  }

  void deleteCard(BuildContext context, CreditCard card) =>
      _deleteCard(context, card).then(
        (_) {
          if (card == _cardNotifier.value) {
            if (_cardNotifier.value == const CreditCard.empty() &&
                creditCards.isNotEmpty) {
              _cardNotifier.value = creditCards.first;
            }
          }
        },
      );

  Future<void> _addCard(CreditCard card) async {
    try {
      await _paymentRepository.addCreditCard(card);
      _cardNotifier.chooseCreditCard(card);
      if (creditCards.map((e) => e.number).contains(card.number)) {
        creditCards.removeWhere((element) => element.number == card.number);
        _paymentSubject.add([...creditCards, card]);
      } else {
        _paymentSubject.add([...creditCards, card]);
      }
    } catch (e) {
      logE(e.toString());
      if (e is InvalidUserIdException) {
        logE(e.message);
      }
      throw Exception('Failed to add credit card.');
    }
  }

  Future<void> _deleteCard(BuildContext context, CreditCard card) async {
    if (_cardNotifier.value == card) {
      _cardNotifier.chooseCreditCard(creditCards.first);
    }
    _paymentSubject.add(creditCards..remove(card));
    await _paymentRepository.deleteCreditCard(card);
    _cardNotifier.deleteCardSelection();
  }

  Future<void> get _addCreditCardsFromDB async {
    try {
      final newCreditCards = await _paymentRepository.getCreditCards();
      _paymentSubject.add(newCreditCards);
      if (_cardNotifier.value == const CreditCard.empty() &&
          newCreditCards.isNotEmpty) {
        _cardNotifier.chooseCreditCard(creditCards.first);
      }
    } catch (e) {
      logE(e.toString());
    }
  }

  Future<List<CreditCard>> get _getCreditCards async {
    try {
      final newCreditCards = await _paymentRepository.getCreditCards();
      if (_cardNotifier.value == const CreditCard.empty() &&
          newCreditCards.isNotEmpty) {
        _cardNotifier.chooseCreditCard(creditCards.first);
      }
      return newCreditCards;
    } catch (e) {
      logE(e.toString());
      return [];
    }
  }

  void removeAllCreditCards() {
    _paymentSubject.add([...creditCards]..removeRange(0, creditCards.length));
  }
}
