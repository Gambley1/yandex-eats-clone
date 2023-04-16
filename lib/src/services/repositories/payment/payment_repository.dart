import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/payment/credit_card.dart';
import 'package:papa_burger/src/services/repositories/payment/base_payment_repository.dart';

import '../../network/api/payment_controller.dart';

@immutable
class PaymentRepository implements BasePaymentRepository {
  const PaymentRepository({
    required PaymentController paymentController,
  }) : _paymentController = paymentController;

  final PaymentController _paymentController;

  @override
  Future<void> addCreditCard(CreditCard card) async {
    _paymentController.saveCreditCardToFirebase(card);
  }

  @override
  Future<void> deleteCreditCard(CreditCard card) async {
    _paymentController.deleteCreditCardFromFirebase(card);
  }

  @override
  Future<List<CreditCard>> getCreditCards() async {
    return _paymentController.getCreditCardsFromFirebase();
  }
}
