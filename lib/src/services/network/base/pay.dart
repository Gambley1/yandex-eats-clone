import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/payment/credit_card.dart';

@immutable
abstract class Pay {
  Future<void> saveCreditCardToFirebase(CreditCard card);
  Future<void> deleteCreditCardFromFirebase(CreditCard card);
}
