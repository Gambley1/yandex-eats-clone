import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/exceptions.dart';
import 'package:papa_burger/src/models/payment/credit_card.dart';
import 'package:papa_burger/src/restaurant.dart' show LocalStorage, logger;

import 'package:papa_burger/src/services/network/base/pay.dart';
import 'package:papa_burger_server/api.dart' as server;

@immutable
class PaymentController implements Pay {
  PaymentController({
    LocalStorage? localStorage,
    server.ApiClient? apiClient,
  })  : _localStorage = localStorage ?? LocalStorage.instance,
        _apiClient = apiClient ?? server.ApiClient();

  final LocalStorage _localStorage;
  final server.ApiClient _apiClient;

  // @override
  // Future<void> saveCreditCardToFirebase(CreditCard card) =>
  //     _saveCreditCardToFirebase(card);

  // @override
  // Future<void> deleteCreditCardFromFirebase(CreditCard card) =>
  //     _deleteCreditCardFromFirebase(card);

  // Future<void> _saveCreditCardToFirebase(CreditCard card) async {
  //   logger.w('Saving $card to Firebase Firestore');
  //   final uid = _firebaseAuth.currentUser?.uid;
  //   if (uid == null) throw Exception('User id equal null');

  //   final mappedCard = card.toMap();
  //   final cardsCollection =
  //       _firebaseFirestore.collection('users').doc(uid).collection('cards');

  //   final querySnapshot =
  //       await cardsCollection.where('number', isEqualTo: card.number).get();

  //   try {
  //     if (querySnapshot.docs.isEmpty) {
  //       logger.w('Adding new Card');
  //       await cardsCollection.add(mappedCard);
  //     } else {
  //       logger.w('Updating Card');
  //       await cardsCollection
  //           .doc(querySnapshot.docs.first.id)
  //           .update(mappedCard);
  //     }
  //   } catch (e) {
  //     logger.e(e.toString());
  //   }
  // }

  // Future<void> _deleteCreditCardFromFirebase(CreditCard card) async {
  //   final uid = _firebaseAuth.currentUser?.uid;

  //   final cardsCollection =
  //       _firebaseFirestore.collection('users').doc(uid).collection('cards');

  //   final querySnapshot =
  //       await cardsCollection.where('number', isEqualTo: card.number).get();

  //   try {
  //     await cardsCollection.doc(querySnapshot.docs.first.id).delete();
  //   } catch (e) {
  //     logger.e(e.toString());
  //   }
  // }

  // Future<List<CreditCard>> getCreditCardsFromFirebase() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return [];

  //   final cardsCollection =
  //       _firebaseFirestore.collection('users').doc(uid).collection('cards');
  //   final querySnapshot = await cardsCollection.get();
  //   final firebaseCreditCards = querySnapshot.docs;

  //   if (firebaseCreditCards.isEmpty) {
  //     return [];
  //   }

  //   logger.w('Firebase Credit Cards $firebaseCreditCards');
  //   return firebaseCreditCards
  //       .map(
  //         (card) => CreditCard.fromJson(card.data()),
  //       )
  //       .toList();
  // }

  Future<List<CreditCard>> getCreditCardsFromDB() async {
    final uid = _localStorage.getToken;

    try {
      final creditCards = await _apiClient.getListUserCreditCards(uid);
      logger.i('Credit cards: $creditCards');

      return creditCards
          .map(
            (e) => CreditCard(
              number: e.number,
              cvv: e.cvv,
              expiry: e.expiryDate,
            ),
          )
          .toList();
    } catch (e) {
      throw apiExceptionsFormatter(e);
    }
  }

  Future<String> saveCreditCardToDB(CreditCard card) async {
    final number = card.number;
    final expiryDate = card.expiry;
    final cvv = card.cvv;
    final uid = _localStorage.getToken;
    logger.i('Expiry date: $expiryDate');

    try {
      final message =
          await _apiClient.createUserCreditCard(uid, number, expiryDate, cvv);
      return message;
    } catch (e) {
      throw apiExceptionsFormatter(e);
    }
  }

  Future<String> deleteCreditCardFromDB(CreditCard card) async {
    final number = card.number;
    final uid = _localStorage.getToken;

    try {
      final message = await _apiClient.deleteUserCreditCard(uid, number);
      return message;
    } catch (e) {
      throw apiExceptionsFormatter(e);
    }
  }
}
