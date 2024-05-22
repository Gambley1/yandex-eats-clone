import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/network/base/pay.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:papa_burger_server/api.dart' as server;

@immutable
class PaymentController implements Pay {
  PaymentController({
    server.ApiClient? apiClient,
  }) : _apiClient = apiClient ?? server.ApiClient();

  final server.ApiClient _apiClient;

  // @override
  // Future<void> saveCreditCardToFirebase(CreditCard card) =>
  //     _saveCreditCardToFirebase(card);

  // @override
  // Future<void> deleteCreditCardFromFirebase(CreditCard card) =>
  //     _deleteCreditCardFromFirebase(card);

  // Future<void> _saveCreditCardToFirebase(CreditCard card) async {
  //   logI('Saving $card to Firebase Firestore');
  //   final uid = _firebaseAuth.currentUser?.uid;
  //   if (uid == null) throw Exception('User id equal null');

  //   final mappedCard = card.toMap();
  //   final cardsCollection =
  //       _firebaseFirestore.collection('users').doc(uid).collection('cards');

  //   final querySnapshot =
  //       await cardsCollection.where('number', isEqualTo: card.number).get();

  //   try {
  //     if (querySnapshot.docs.isEmpty) {
  //       logI('Adding new Card');
  //       await cardsCollection.add(mappedCard);
  //     } else {
  //       logI('Updating Card');
  //       await cardsCollection
  //           .doc(querySnapshot.docs.first.id)
  //           .update(mappedCard);
  //     }
  //   } catch (e) {
  //     logI(e.toString());
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
  //     logI(e.toString());
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

  //   logI('Firebase Credit Cards $firebaseCreditCards');
  //   return firebaseCreditCards
  //       .map(
  //         (card) => CreditCard.fromJson(card.data()),
  //       )
  //       .toList();
  // }

  Future<List<CreditCard>> getCreditCardsFromDB() async {
    final uid = LocalStorage().getToken;

    try {
      final creditCards = await _apiClient.getListUserCreditCards(uid);
      logI('Credit cards: $creditCards');

      return creditCards
          .map(
            (e) =>
                CreditCard(number: e.number, cvv: e.cvv, expiry: e.expiryDate),
          )
          .toList();
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  Future<String> saveCreditCardToDB(CreditCard card) async {
    final number = card.number;
    final expiryDate = card.expiry;
    final cvv = card.cvv;
    final uid = LocalStorage().getToken;
    logI('Expiry date: $expiryDate');

    try {
      final message =
          await _apiClient.createUserCreditCard(uid, number, expiryDate, cvv);
      return message;
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  Future<String> deleteCreditCardFromDB(CreditCard card) async {
    final number = card.number;
    final uid = LocalStorage().getToken;

    try {
      final message = await _apiClient.deleteUserCreditCard(uid, number);
      return message;
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }
}
