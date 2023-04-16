import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/payment/credit_card.dart';
import 'package:papa_burger/src/restaurant.dart' show logger;

import '../base/pay.dart';

@immutable
class PaymentController implements Pay {
  PaymentController({
    FirebaseFirestore? firebaseFirestore,
    FirebaseAuth? firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> saveCreditCardToFirebase(CreditCard card) =>
      _saveCreditCardToFirebase(card);

  @override
  Future<void> deleteCreditCardFromFirebase(CreditCard card) =>
      _deleteCreditCardFromFirebase(card);

  Future<void> _saveCreditCardToFirebase(CreditCard card) async {
    logger.w('Saving $card to Firebase Firestore');
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) throw Exception('User id equal null');

    final mappedCard = card.toMap();
    final cardsCollection =
        _firebaseFirestore.collection('users').doc(uid).collection('cards');

    final querySnapshot =
        await cardsCollection.where('number', isEqualTo: card.number).get();

    try {
      if (querySnapshot.docs.isEmpty) {
        logger.w('Adding new Card');
        cardsCollection.add(mappedCard);
      } else {
        logger.w('Updating Card');
        cardsCollection.doc(querySnapshot.docs.first.id).update(mappedCard);
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _deleteCreditCardFromFirebase(CreditCard card) async {
    final uid = _firebaseAuth.currentUser?.uid;

    final cardsCollection =
        _firebaseFirestore.collection('users').doc(uid).collection('cards');

    final querySnapshot =
        await cardsCollection.where('number', isEqualTo: card.number).get();

    try {
      cardsCollection.doc(querySnapshot.docs.first.id).delete();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<List<CreditCard>> getCreditCardsFromFirebase() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    final cardsCollection =
        _firebaseFirestore.collection('users').doc(uid).collection('cards');
    final querySnapshot = await cardsCollection.get();
    final firebaseCreditCards = querySnapshot.docs;

    if (firebaseCreditCards.isEmpty) {
      return [];
    }

    logger.w('Firebase Credit Cards $firebaseCreditCards');
    return firebaseCreditCards
        .map(
          (card) => CreditCard.fromJson(card.data()),
        )
        .toList();
  }
}
