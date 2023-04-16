import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/payment/credit_card.dart';

@immutable
abstract class BasePaymentRepository {
  Future<void> addCreditCard(CreditCard card);
  Future<void> deleteCreditCard(CreditCard card);
  Future<List<CreditCard>> getCreditCards();
}
