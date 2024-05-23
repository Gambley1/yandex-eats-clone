import 'package:flutter/foundation.dart' show immutable;
import 'package:shared/shared.dart';

@immutable
abstract class BasePaymentsRepository {
  Future<void> addCreditCard(CreditCard card);
  Future<void> deleteCreditCard(CreditCard card);
  Future<List<CreditCard>> getCreditCards();
}
