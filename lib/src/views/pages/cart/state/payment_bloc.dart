import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show BuildContext;
import 'package:papa_burger/src/restaurant.dart'
    show NavigatorExtension, logger;
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;

import '../../../../models/payment/credit_card.dart';
import '../../../../services/network/api/payment_controller.dart';
import '../../../../services/repositories/payment/payment_repository.dart';

@immutable
class PaymentBloc {
  static final PaymentBloc _instance = PaymentBloc._privateConstructor();

  factory PaymentBloc() => _instance;

  PaymentBloc._privateConstructor() {
    logger.w('First Instance of PaymentBloc');
    _addCreditCardsFromFirebase();
  }

  final PaymentRepository _paymentRepository = PaymentRepository(
    paymentController: PaymentController(),
  );

  final SelectedCardNotifier _cardNotifier = SelectedCardNotifier();

  final _paymentSubject = BehaviorSubject<List<CreditCard>>.seeded([]);

  Stream<List<CreditCard>> get creditCardsStream =>
      _paymentSubject.distinct().asyncMap(
        (cards) async {
          final newCards = await _getCreditCards();
          cards = newCards;
          return cards;
        },
      );

  List<CreditCard> get creditCards => _paymentSubject.value;

  void addCard(BuildContext context, CreditCard card) =>
      _addCard(context, card);

  void deleteCard(BuildContext context, CreditCard card) =>
      _deleteCard(context, card).then(
        (_) {
          if (_cardNotifier.value == const CreditCard.empty() &&
              creditCards.isNotEmpty) {
            _cardNotifier.value = creditCards.first;
          }
        },
      );

  Future<void> _addCard(BuildContext context, CreditCard card) async {
    try {
      _paymentRepository.addCreditCard(card);
      _cardNotifier.chooseCreditCard(card);
      if (creditCards.map((e) => e.number).contains(card.number)) {
        logger.w('Removing Credit card');
        creditCards.removeWhere((element) => element.number == card.number);
        logger.w('Then adding Credit card');
        _paymentSubject.add([...creditCards, card]);
      } else {
        _paymentSubject.add([...creditCards, card]);
      }
      context.pop();
    } catch (e) {
      logger.e(e.toString());
      return;
    }
  }

  Future<void> _deleteCard(BuildContext context, CreditCard card) async {
    _paymentSubject.add([...creditCards]..remove(card));
    _paymentRepository.deleteCreditCard(card);
    _cardNotifier.deleteCardSelection();
  }

  Future<void> _addCreditCardsFromFirebase() async {
    try {
      final newCreditCards = await _paymentRepository.getCreditCards();
      _paymentSubject.add(newCreditCards);
      if (_cardNotifier.value == const CreditCard.empty() &&
          newCreditCards.isNotEmpty) {
        _cardNotifier.value = creditCards.last;
      }
    } catch (e) {
      logger.e(e.toString());
      _paymentSubject.addError('Error on server while getting credit cards.');
    }
  }

  Future<List<CreditCard>> _getCreditCards() async {
    try {
      final newCreditCards = await _paymentRepository.getCreditCards();
      if (_cardNotifier.value == const CreditCard.empty() &&
          newCreditCards.isNotEmpty) {
        _cardNotifier.value = creditCards.last;
      }
      return newCreditCards;
    } catch (e) {
      logger.e(e.toString());
      _paymentSubject.addError('Error on server while getting credit cards.');
      rethrow;
    }
  }

  void removeAllCreditCards() {
    _paymentSubject.add([...creditCards]..removeRange(0, creditCards.length));
  }
}
