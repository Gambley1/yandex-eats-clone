import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/payment/credit_card.dart';
import 'package:papa_burger/src/services/network/api/payment_controller.dart';
import 'package:papa_burger/src/services/repositories/payment/base_payment_repository.dart';

@immutable
class PaymentRepository implements BasePaymentRepository {
  const PaymentRepository({
    required PaymentController paymentController,
  }) : _paymentController = paymentController;

  final PaymentController _paymentController;

  @override
  Future<void> addCreditCard(CreditCard card) async {
    // await _paymentController.saveCreditCardToFirebase(card);
    await _paymentController.saveCreditCardToDB(card);
  }

  @override
  Future<void> deleteCreditCard(CreditCard card) async {
    // await _paymentController.deleteCreditCardFromFirebase(card);

    await _paymentController.deleteCreditCardFromDB(card);
  }

  @override
  Future<List<CreditCard>> getCreditCards() async {
    // return _paymentController.getCreditCardsFromFirebase();
    return _paymentController.getCreditCardsFromDB();
  }
}
