import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/credit_card.dart';

@immutable
abstract class BasePaymentsRepository {
  Future<void> addCreditCard(CreditCard card);
  Future<void> deleteCreditCard(CreditCard card);
  Future<List<CreditCard>> getCreditCards();
}
